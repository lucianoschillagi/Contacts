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
Un listado de contactos indexados alfabéticamente en secciones.
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
	
	/// Internet Recheability ..........................................
	let connection = ConnectionPossibilities(connection: .none)
	//let recheability = Reachability()!
	
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
			
			// Internet Recheability
			//internetRecheability()
			
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
	
	// task: obtener un array de diccionarios que representan los datos de contacto de diferentes usuarios
	func startRequest(){
		
		IguanaFixClient.getContactsObject { (success, contactObject, error) in
			
			DispatchQueue.main.async {
				if success {
					if let contactObject = contactObject {
						self.allContacts = contactObject
						}
						self.getContactNames()
						self.tableView.reloadData()
						self.stopActivityIndicator()
					} else {
						self.displayAlertView(nil, error)
				}
			}
		}
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
	
	
	//*****************************************************************
	// MARK: - Alert View
	//*****************************************************************
	
	/**
	Muestra al usuario un mensaje acerca de porqué la solicitud falló.
	
	- Parameter title: El título del error.
	- Parameter message: El mensaje acerca del error.
	
	*/
	func displayAlertView(_ title: String? = "Request Error", _ error: String?) {
		
		// si ocurre un error en la solicitud, mostrar una vista de alerta
		if error != nil {
			
			let alertController = UIAlertController(title: title, message: error, preferredStyle: .alert)
			let OKAction = UIAlertAction(title: "OK", style: .default) { action in
				
			}
			alertController.addAction(OKAction)
			self.present(alertController, animated: true) {}
		}
	}
	
	
	//*****************************************************************
	// MARK: - Internet Connection
	//*****************************************************************
	
//	/// task: comprobar si hay conexión a internet y actuar en consecuencia
//	func internetRecheability() {
//
//		// si hay internet
//		if recheability.connection != .none {
//
//			print("hay conexión, se despide el alert view y se realiza una nueva solicitud")
//
//		} else {
//			DispatchQueue.main.async {
//				self.displayAlertView(Errors.Message.noInternet.title, Errors.Message.no_Internet.description)
//			}
//		}
//	}
	

} // end class


	//*****************************************************************
	// MARK: - Table View Data Source Methods
	//*****************************************************************

extension ContactsViewController: UITableViewDataSource {
	
//	// task: determinar la cantidad de secciones que tendrá la tabla
//	func numberOfSections(in tableView: UITableView) -> Int {
//		// 1- la cantidad de secciones se corresponde con la cantidad de títulos de sección por nombre
//		return conctactNamesSectionTitles.count
//	}
	
	
	// task: determinar la cantidad de celdas que mostrará la tabla en cada sección
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		// si está filtrando, contar el array que contiene los elementos filtrados
		if isFiltering() {
			return filteredContacts.count
		}
		// sino, contar el array que contiene todos los elementos
		return allContacts.count
		
		
//		// obtiene la inicial de cada nombre de acuerdo a la inicial asignada como encabezado de cada sección
//		let nameKey = conctactNamesSectionTitles[section]
//		debugPrint("name key \(nameKey)")
//		// obtiene los valores asociados a cada inicial
//		if let nameValues = contactNamesDictionary[nameKey] {
//			// cuenta los valores que contiene cada inicial, es decir, cada sección de la tabla
//			return nameValues.count
//		}
//
//		return 0

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

//		// Configure the cell...
//		let nameKey = conctactNamesSectionTitles[indexPath.section]
//		if let nameValue = contactNamesDictionary[nameKey] {
//			debugPrint("Los nombres de los contactos que empiezan con tal letra son: \(nameValue)")
//			cell.textLabel?.text = nameValue[indexPath.row]
//		}
//
//
		return cell
	}
	
//	// task: mostrar el encabezado de cada sección
//	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//		return conctactNamesSectionTitles[section]
//	}
//
//	// task: agregar el indexado de la tabla (vista del borde izquierdo)
//	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//		return conctactNamesSectionTitles
//	}
	

} // end ext


extension ContactsViewController: UISearchResultsUpdating {
	// MARK: - UISearchResultsUpdating Delegate
	
	// task: actualizar los resultados de la búsqueda cada vez que el usuario ingresa algún caracter en la barra de búsqueda
	func updateSearchResults(for searchController: UISearchController) {
		// le pasa a este método el texto que el usuario ingresó en la barra de búsqueda 👏
		filterContentForSearchText(searchController.searchBar.text!)
	}
}


