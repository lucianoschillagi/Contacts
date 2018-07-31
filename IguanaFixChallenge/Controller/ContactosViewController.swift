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

class ContactosViewController: UIViewController {
	
	//*****************************************************************
	// MARK: - IBOutlets
	//*****************************************************************
	
	@IBOutlet weak var contactsTableView: UITableView!
	//TODO: activar el indicador de actividad en red
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	//*****************************************************************
	// MARK: - Properties
	//*********************var*****************************************
	
	//var movies: [TMDBMovie] = [TMDBMovie]()
	var contacts: [Contact] = [Contact]() // VER ESTO 👈

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
		
		// networking
		getContactsObjetcs()
	
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

	} // end class


	//*****************************************************************
	// MARK: - Table View Data Source Methods
	//*****************************************************************

extension ContactosViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return contactsJSONArray.count }

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cellReuseIdentifier = "ContactsTableViewCell"
		_ = contactsJSONArray[(indexPath as NSIndexPath).row]
		let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ContactsCell
		let completeName = self.firstNameArray[indexPath.row] + " " + self.lastNameArray[indexPath.row]
		cell.contactNameLabel.text = completeName

		return cell
	}
	
	
	//func tableView(_:didSelectRowAt:)

} // end ext

extension ContactosViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
			let contact = contactsJSONArray[(indexPath as NSIndexPath).row]
			let controller = storyboard!.instantiateViewController(withIdentifier: "ContactDetailViewController") as! ContactDetailViewController
			controller.contact = [contact]
			navigationController!.pushViewController(controller, animated: true)
		
		
	}
	
	
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		let movie = movies[(indexPath as NSIndexPath).row]
//		let controller = storyboard!.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
//		controller.movie = movie
//		navigationController!.pushViewController(controller, animated: true)
//	}
	
	
}


