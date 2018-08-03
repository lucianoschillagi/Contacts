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
	
	// esconde la barra de estado
	override var prefersStatusBarHidden: Bool { return true }
	
	//*****************************************************************
	// MARK: - VC Life Cycle
	//*****************************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
		
			// configura el controlador de búsqueda #SEARCH CONTROLLER
			setupSearchController()
			
			// solicita los contactos al servidor #NETWORKING
			getContactsObjetcs()
			
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
	func getContactsObjetcs() {
	
		// 1. realiza la llamada a la API, a través de la función request() de Alamofire, utilizando la URL de Iguana Fix (Apiary) 🚀
		Alamofire.request(IguanaFixClient.ApiURL).responseJSON { response in
			
			// response status code
			if let status = response.response?.statusCode {
				switch(status){
				case 200:
					print("example success")
				default:
					print("error with response status: \(status)")
				}
			}
				// 2.  almacena la respuesta del servidor (response.result.value) en la constante 'jsonObjectResult' 📦
				if let jsonObjectResult = response.result.value {
					
					self.stopActivityIndicator()

					// 3. utiliza la estructura 'contactsJSONArray' para almacenar la respuesta del servidor, especificando que se trata de un Array
					// sabemos esto, porque conocemos la estructura que tiene nuestro json en Apiary
					let resultsContacts = Contact.contactsFromResults(jsonObjectResult as! [[String : AnyObject]])
					// asigna los resultados de los contactos obtenidos al array 'allContacts'
					self.allContacts = resultsContacts
					
					// 4. por último, es necesario que recarguemos la TableView, usando la función reloadData(), para que nuestra TableView pueda mostrar los datos que acabamos de recuperar del servidor.
					self.tableView.reloadData()
					
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
	
	// task: determinar la cantidad de celdas que mostrará la tabla
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		// si está filtrando, contar el array que contiene los elementos filtrados
		if isFiltering() {
			return filteredContacts.count
		}
		// sino, contar el array que contiene todos los elementos
		return allContacts.count
		
	}
	
	// task: configurar la celda
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cellReuseIdentifier = "ContactsTableViewCell"
		let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ContactsCell
		
		// instancia del objeto 'Contacto'
		let contact: Contact
		// muestra el array con todos los resultados o con los filtrados según si el usuario esté filtrando o no
		if isFiltering() {
			contact = filteredContacts[indexPath.row]
		} else {
			contact = allContacts[indexPath.row]
		}
			let completeName = contact.firstName + " " + contact.lastName
			cell.label.text = completeName

		return cell
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


