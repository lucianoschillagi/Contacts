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
	@IBOutlet weak var contactsTableView: UITableView!
	// el indicador de actividad en red
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	//*****************************************************************
	// MARK: - Properties
	//*********************var*****************************************
	
	// una instancia del vc 'ContactDetailViewController', en principio a nil
	var detailViewController: ContactDetailViewController? = nil
	
	// un controlador (gestor) para las búsquedas en la tabla
	let searchController = UISearchController(searchResultsController: nil)
	
	//var movies: [TMDBMovie] = [TMDBMovie]()
	
	// DOS fuentes de datos: una almacena todos los contactos, la otra sólo los que están siendo filtrados
	// un array que contiene todos los contactos (recibidos mediante la solicitud web)
	var contacts = [Contact]()
	// una array que contiene los SÓLO los contactos filtrados
	var filteredContacts = [Contact]()

	// model (provisorio)
	// almacena el resultado obtenido (el JSON) de la solicitud
	var contactsJSONArray: [[String:Any]] = []
	var firstNameArray: [String] = []
	var lastNameArray: [String] = []
	
	// esconde la barra de estado
	override var prefersStatusBarHidden: Bool { return true }
	
	
	//*****************************************************************
	// MARK: - VC Life Cycle
	//*****************************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
		
		// 'ContactsViewController' pasa a ser delegado de 'search controller'
		searchController.searchBar.delegate = self
			
		// solicita los contactos al servidor
		getContactsObjetcs()
			
			// modelo provisorio
			contacts = [
			
				Contact(firstName: "Lucianoo", lastName: "Schillagi"),
				Contact(firstName: "José", lastName: "Perez"),
				Contact(firstName: "Alba", lastName: "Noto"),
				Contact(firstName: "Dulcinea", lastName: "Zacarias"),
				Contact(firstName: "Pedro", lastName: "Alvarado")

				
				]

			
			// configura del controlador de búsqueda
			searchController.searchResultsUpdater = self
			searchController.obscuresBackgroundDuringPresentation = false
			searchController.searchBar.placeholder = "Search Contacts"
			navigationItem.searchController = searchController
			definesPresentationContext = true
			
			if let splitViewController = splitViewController {
				let controllers = splitViewController.viewControllers
				detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ContactDetailViewController
			}
	
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		
		activityIndicator.alpha = 1.0
		activityIndicator.startAnimating()
		
		if splitViewController!.isCollapsed {
			if let selectionIndexPath = self.contactsTableView.indexPathForSelectedRow {
				self.contactsTableView.deselectRow(at: selectionIndexPath, animated: animated)
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
		Alamofire.request(IguanaFixClient.Constants.ApiURL).responseJSON { response in
			
			// MARK: response status code
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
					
					self.activityIndicator.alpha = 0.0
					self.activityIndicator.stopAnimating()
					
					// imprime el resultado
					print("👏\(jsonObjectResult)")
					
					// 3. utiliza la estructura 'contactsJSONArray' para almacenar la respuesta del servidor, especificando que se trata de un Array
					// sabemos esto, porque conocemos la estructura que tiene nuestro json en Apiary
					self.contactsJSONArray = jsonObjectResult as! [[String:Any]]
					
					// 4. Recorremos 'contactsJSONArray' y vamos recuperando cada uno de los diccionarios (que corresponden a cada uno de los contactos)
					for contactInfoDictionary in self.contactsJSONArray {
						
						//5. Cada vez que recuperamos uno de los diccionarios, que representa a un 'contacto', recuperamos su nombre, a través de la clave “first_name” y "last_name"
						// y los almacenamos en los arrays 'first_name' y 'last_name' respectivamente.
						
						// 'first_name'...
						let firstNameValue: String = contactInfoDictionary[IguanaFixClient.Constants.JSONResponseKeys.FirstName] as! String
						self.firstNameArray.append(firstNameValue)
						print("🏄🏻‍♂️\(self.firstNameArray)")

						// ...y 'last_name'
						let lastNameValue: String = contactInfoDictionary[IguanaFixClient.Constants.JSONResponseKeys.LastName] as! String
						self.lastNameArray.append(lastNameValue)
						print("😆\(self.lastNameArray)")
						
					}
					
					// 6. por último, es necesario que recarguemos la TableView, usando la función reloadData(), para que nuestra TableView pueda mostrar los datos que acabamos de recuperar del servidor.
					self.contactsTableView.reloadData()
					
				}
			
			}

		}

	
	//*****************************************************************
	// MARK: - Helper methods
	//*****************************************************************
	// task: observar si la barra de búsqueda está vacía o no.
	func searchBarIsEmpty() -> Bool {
		// Returns true if the text is empty or nil
		return searchController.searchBar.text?.isEmpty ?? true
	}
	
	
	// task: filtrar contenido según el texto de búsqueda 👏
	func filterContentForSearchText(_ searchText: String) {
		filteredContacts = contacts.filter({( contact : Contact) -> Bool in
			return contact.firstName.lowercased().contains(searchText.lowercased())
		})
		
		contactsTableView.reloadData()
	}

	
	
	//*****************************************************************
	// MARK: - Segues
	//*****************************************************************
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail" {
			if let indexPath = contactsTableView.indexPathForSelectedRow {
				
				// esta pieza provee el array de correspondiente a la lógica, si está filtrando
				// provee el index path de ese array, caso contrario del index path del array con todos los contactos
				
				// el contacto seleccionado
				let contact: Contact
				if isFiltering() {
					contact = filteredContacts[indexPath.row]
				} else {
					contact = contacts[indexPath.row]
				}
			
				let controller = (segue.destination as! UINavigationController).topViewController as! ContactDetailViewController
				controller.detailContact = contact
				controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
				controller.navigationItem.leftItemsSupplementBackButton = true
			}
		}
	}
	
	
	
} // end class




	//*****************************************************************
	// MARK: - Table View Data Source Methods
	//*****************************************************************

extension ContactsViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return contactsJSONArray.count }
	
	// task: determinar si se están filtrando resultados o no
	func isFiltering() -> Bool {
		// si el controlador de búsqueda está activo y la barra de búsqueda no está vacía,
		// quiere decir que entonces se están filtrando resultados
		return searchController.isActive && !searchBarIsEmpty()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cellReuseIdentifier = "ContactsTableViewCell"
		_ = contactsJSONArray[(indexPath as NSIndexPath).row]
		let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ContactsCell
		let completeName = self.firstNameArray[indexPath.row] + " " + self.lastNameArray[indexPath.row]
		cell.label.text = completeName
		
//				let cellReuseIdentifier = "ContactsTableViewCell"
//				_ = contacts[(indexPath as NSIndexPath).row]
//				let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ContactsCell
//				let contact = contacts[indexPath.row]
//
//			// asigna al texto de la etiqueta de CADA celda, el nombre del contacto correspondiente
//			cell.label!.text = contact.firstName + " " + contact.lastName


		return cell
	}
	
	
//	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		if segue.identifier == "showDetail" {
//			if let indexPath = contactsTableView.indexPathForSelectedRow {
//				let contact = contactsJSONArray[indexPath.row]
//				let controller = (segue.destination as! UINavigationController).topViewController as! ContactDetailViewController
////				controller.detailCandy = candy
////				controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
////				controller.navigationItem.leftItemsSupplementBackButton = true
//			}
//		}
//	}
	
	
	
	
	//func tableView(_:didSelectRowAt:)

} // end ext

//extension ContactsViewController: UITableViewDelegate {
//
//	// task: ejecuta algo si una fila es seleccionada
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//			let contact = contactsJSONArray[(indexPath as NSIndexPath).row]
//			let controller = storyboard!.instantiateViewController(withIdentifier: "ContactDetailViewController") as! ContactDetailViewController
//			controller.contact = [contact]
//			navigationController!.pushViewController(controller, animated: true)
//
//
//	}

	

	
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		let movie = movies[(indexPath as NSIndexPath).row]
//		let controller = storyboard!.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
//		controller.movie = movie
//		navigationController!.pushViewController(controller, animated: true)
//	}
	



extension ContactsViewController: UISearchResultsUpdating {
	// MARK: - UISearchResultsUpdating Delegate
	func updateSearchResults(for searchController: UISearchController) {
		// le pasa a este método el texto que el usuario ingresó en la barra de búsqueda 👏
		filterContentForSearchText(searchController.searchBar.text!)
	}
}

// MARK: - UISearchBar Delegate
extension ContactsViewController: UISearchBarDelegate {
	
	// task: indicar qué botón de ´alcance´ (scope) ha sido seleccionado
	func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		// le pasa a este método el índice del ´botón de alcance´ que fue seleccionado
		filterContentForSearchText(searchBar.text!)
	}
}

