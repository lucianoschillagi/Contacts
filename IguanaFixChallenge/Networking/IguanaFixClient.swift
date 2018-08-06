//
//  IguanaFixClient.swift
//  IguanaFixChallenge
//
//  Created by Luciano Schillagi on 26/07/2018.
//  Copyright © 2018 luko. All rights reserved.
//

/* Networking */

import Foundation
import Alamofire

/* Abstract:
Una clase que encapsula los métodos para realizar la solicitud web.
*/

class IguanaFixClient {
	
	// task: obtener mediante una solicitud web un array de diccionario que representan un listado de contactos
	static func getContactsObject(_ completionHandlerForContactObject: @escaping ( _ success: Bool, _ contactObject: [Contact]?, _  errorString: String?) -> Void)  {
		
		// 1. realiza la llamada a la API, a través de la función request() de Alamofire, utilizando la URL de Iguana Fix (Apiary) 🚀
		Alamofire.request(IguanaFixClient.ApiURL).responseJSON { response in
			
			// response status code
			if let status = response.response?.statusCode {
				switch(status){
				case 200:
					print("example success")
				default:
					let errorMessage = "error with response status: \(status)"
					completionHandlerForContactObject(false, nil, errorMessage)
				}
			}
			// 2.  almacena la respuesta del servidor (response.result.value) en la constante 'jsonObjectResult' 📦
			if let jsonObjectResult = response.result.value {

				// 3. almacena el resultado de la solicitud en la constante 'resultsContacts'
				let resultsContacts = Contact.contactsFromResults(jsonObjectResult as! [[String : AnyObject]])
				// le pasa al completion handler el objeto recibido 'resultContacts' y que la solcitud fue exitosa
				completionHandlerForContactObject(true, resultsContacts, nil)
				
			}
			
		}
		
		
		
		
	}

}

