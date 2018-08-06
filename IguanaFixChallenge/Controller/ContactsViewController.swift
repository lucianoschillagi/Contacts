//
//  ContactosViewController.swift
//  IguanaFixChallenge
//
//  Created by Luciano Schillagi on 26/07/2018.
//  Copyright © 2018 luko. All rights reserved.
//

/* Controller */

import UIKit
import Alamofire

/* Abstract:
Un listado de contactos.
*/

class ContactsViewController: UIViewController {
	
	//*****************************************************************
	// MARK: - IBOutlets
	//*****************************************************************
	
	// la tabla que lista los contactos
	@IBOutlet weak var tableView: UITableView!
	// el indicador de actividad en red
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	//*****************************************************************
	// MARK: - Properties
	//*****************************************************************
	
	// una instancia del vc 'ContactDetailViewController', en principio a nil
	var detailViewController: ContactDetailViewController? = nil
	
	// un controlador (gestor) para las búsquedas en la tabla
	let searchController = UISearchController(searchResultsController: nil)

	// DOS fuentes de datos: una almacena todos los contactos, la otra sólo los que están siendo filtrados
	// un array que contiene todos los contactos (recibidos mediante la solicitud web)
	var allContacts = [Contact]()
	// una array que contiene los SÓLO los contactos filtrados
	var filteredContacts = [Contact]()
	
	// Index Table View
	// un array que contiene los nombres de los contactos
	var contactNames = [String]()
	// un array que contiene el nombre de los contactos FILTRADOS
	var filteredContactNames = [String]()
	// el index y los nombres de TODOS los contactos que contiene cada letra del index
	var contactNamesDictionary = [String: [String]]()
	// los títulos de cada sección del index
	var conctactNamesSectionTitles = [String]()
	
	// esconde la barra de estado
	override var prefersStatusBarHidden: Bool { return true }
	
	//*****************************************************************
	// MARK: - VC Life Cycle
	//*****************************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
		
			// configura el controlador de búsqueda #SEARCH CONTROLLER
			setupSearchController()
			
			// solicita los contactos al servidor #NETWORKING	🚀
			startRequest()
			
			// poner el 'contact detail view controller' #NAVIGATION
			setContactDetailVC()
			
			// activar el indicador de actividad
			startActivityIndicator()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
		if splitViewController!.isCollapsed {
			if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
				self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
			}
		}
		super.viewWillAppear(animated)
	}
	
	//*****************************************************************
	// MARK: - Networking methods
	//*****************************************************************
	
	// task: obtener un array de objetos, diccionarios que representan los datos de diferentes usuarios
	func startRequest(){
		
		IguanaFixClient.getContactsObject { (success, contactObject, error) in
			
			DispatchQueue.main.async {
				if success {
					self.allContacts = contactObject
					self.getContactNames()
					self.tableView.reloadData()
					self.stopActivityIndicator()
				} else {
					print(error)
				}
			}
		}
	}
	
	//*****************************************************************
	// MARK: - Helper methods
	//*****************************************************************
	
	// task: configurar al controlador de búsqueda
	func setupSearchController() {
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Contacts"
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}
	
	// task: observar si la barra de búsqueda está vacía o no.
	func searchBarIsEmpty() -> Bool {
		// Returns true if the text is empty or nil
		return searchController.searchBar.text?.isEmpty ?? true
	}
	
	// task: filtrar contenido según el texto de búsqueda 👏
	func filterContentForSearchText(_ searchText: String) {
		filteredContacts = allContacts.filter({( contact : Contact) -> Bool in
			return contact.firstName.lowercased().contains(searchText.lowercased())
		})
		tableView.reloadData()
		debugPrint("Los contactos filtrados actualmente son: \(filteredContacts)")
	}
	
	// task: determinar si actualmente se están filtrando resultados o no
	func isFiltering() -> Bool {
		return searchController.isActive && !searchBarIsEmpty()
	}
	
	
	// task: rellenar la propiedad 'contactNames' con los nombres de todos los contactos 👏
	func getContactNames() {
		
		// si está fitrando...
		if isFiltering() {
			
			for filteredContactName in self.filteredContacts {
				let fullName = filteredContactName.lastName + " " + filteredContactName.firstName
				self.filteredContactNames.append(fullName)
				debugPrint("😅 Este es el listado de los nombres filtrados: \(self.filteredContactNames)")
			}
			
			// si NO está filtrando
		} else {
			
			for contactName in self.allContacts {
				let fullName = contactName.lastName + " " + contactName.firstName
				self.contactNames.append(fullName)
				debugPrint("🍎 Este es el listado de los nombres completos: \(self.contactNames)")
			}
			
			
			
			
		}
		
		
		
		
		
		
		
		getInitialOfTheNames()
	}
	
	// task: obtener las iniciales de los nombres
	func getInitialOfTheNames() {
		
		// para luego indexar la table
		// itera el array 'contact names'
		for name in self.contactNames {
			// extrae la inicial de cada nombre
			let nameKey = String(name.prefix(1))
			// y se usa como clave de ´contactNamesDictionary´
			if var nameValues = contactNamesDictionary[nameKey] {
				// 2-o si la clave ya existe, agrega ese nuevo nombre al array
				nameValues.append(name)
				contactNamesDictionary[nameKey] = nameValues
			} else {
				// 1-con esta clave se crea una nueva serie de nombres
				contactNamesDictionary[nameKey] = [name]
			}
			
		}
		debugPrint("😛\(self.contactNamesDictionary)")
		// asigna las claves de cada sección a las claves de cada uno de los elementos del diccionario 🔌
		conctactNamesSectionTitles = [String](contactNamesDictionary.keys)
		conctactNamesSectionTitles = conctactNamesSectionTitles.sorted(by: { $0 < $1 })
		debugPrint("las iniciales de las secciones son las siguientes: \(conctactNamesSectionTitles)")
		
	}
	
	func startActivityIndicator() {
		activityIndicator.alpha = 1.0
		activityIndicator.startAnimating()
	}
	
	func stopActivityIndicator() {
		self.activityIndicator.alpha = 0.0
		self.activityIndicator.stopAnimating()
	}

	//*****************************************************************
	// MARK: - Navigation
	//*****************************************************************
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if segue.identifier == "showDetail" {
			// pasa el index path de la fila seleccionada en la tabla
			if let indexPath = tableView.indexPathForSelectedRow {
				// el contacto seleccionado
				let contact: Contact
				// si está filtrando provee el array de los contactos filtrados
				if isFiltering() {
					contact = filteredContacts[indexPath.row]
				} else {
					// caso contrario, el de todos los contactos
					contact = allContacts[indexPath.row]
				}
				debugPrint("Los datos del contacto seleccionado son: \(contact.firstName)")
				// navega hacia el vc de detalle
				let controller = (segue.destination as! UINavigationController).topViewController as! ContactDetailViewController
				// le pasa a la propiedad 'detailContact' de 'ContactDetailViewController' el objeto correspondiente a la dirección del array correspondiente
				controller.detailContact = contact
				controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
				controller.navigationItem.leftItemsSupplementBackButton = true
			}
		}
	}
	

	func setContactDetailVC() {
		if let splitViewController = splitViewController {
			let controllers = splitViewController.viewControllers
			detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ContactDetailViewController
		}
	}
	
} // end class


	//*****************************************************************
	// MARK: - Table View Data Source Methods
	//*****************************************************************

extension ContactsViewController: UITableViewDataSource {
	
	// task: determinar la cantidad de secciones que tendrá la table
	func numberOfSections(in tableView: UITableView) -> Int {
		// 1- la cantidad de secciones se corresponde con la cantidad de títulos de sección por nombre
		return conctactNamesSectionTitles.count
	}
	
	
	// task: determinar la cantidad de celdas que mostrará la tabla en cada sección
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
//		// si está filtrando, contar el array que contiene los elementos filtrados
//		if isFiltering() {
//			return filteredContacts.count
//		}
//		// sino, contar el array que contiene todos los elementos
//		return allContacts.count
		
		
		let nameKey = conctactNamesSectionTitles[section]
		if let nameValues = contactNamesDictionary[nameKey] {
			return nameValues.count
		}
		
		return 0
		
		
		
		
		
	}
	
	// task: configurar la celda
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cellReuseIdentifier = "ContactsTableViewCell"
		let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ContactsCell
		
//		// instancia del objeto 'Contacto'
//		let contact: Contact
//		// muestra el array con todos los resultados o con los filtrados según si el usuario esté filtrando o no
//		if isFiltering() {
//			contact = filteredContacts[indexPath.row]
//		} else {
//			contact = allContacts[indexPath.row]
//		}
//			let completeName = contact.firstName + " " + contact.lastName
//			cell.label.text = completeName

		// Configure the cell...
		let nameKey = conctactNamesSectionTitles[indexPath.section]
		if let nameValue = contactNamesDictionary[nameKey] {
			cell.textLabel?.text = nameValue[indexPath.row]
		}
		
		
		return cell
	}
	
	// task: mostrar el encabezado de cada sección
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return conctactNamesSectionTitles[section]
	}

	// task: agregar el indexado de la tabla (vista del borde izquierdo)
	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return conctactNamesSectionTitles
	}
	

} // end ext


extension ContactsViewController: UISearchResultsUpdating {
	// MARK: - UISearchResultsUpdating Delegate
	
	// task: actualizar los resultados de la búsqueda del usuario
	func updateSearchResults(for searchController: UISearchController) {
		// le pasa a este método el texto que el usuario ingresó en la barra de búsqueda 👏
		filterContentForSearchText(searchController.searchBar.text!)
	}
}


