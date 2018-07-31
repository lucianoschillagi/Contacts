//
//  ContactObject.swift
//  IguanaFixChallenge
//
//  Created by Luciano Schillagi on 29/07/2018.
//  Copyright © 2018 luko. All rights reserved.
//

/* Abstract:
Una objeto preparada para recibir, mapear y almacenar (para usar cuando sea necesario) los datos de los contactos.
*/

import Foundation

struct Contact {

	var firstName: String
	var lastName: String
	
		// MARK: Initializer
		init(dictionary: [String:AnyObject]) { // esta estructura acepta una diccionario [String:Any] como argumento
			if let stringFirstName = dictionary[IguanaFixClient.Constants.JSONResponseKeys.FirstName] as? String {
				firstName = stringFirstName
			} else {
				firstName = ""
			}
	
			if let stringLastName = dictionary[IguanaFixClient.Constants.JSONResponseKeys.LastName] as? String {
				lastName = stringLastName
			} else {
				lastName = ""
			}
	
	}
	
	
		/**
		Toma el array de diccionarios obtenidos en el objeto 'Student Location' y devuelve una estructura que contiene un array de diccionarios (StudentInformation). Convierte el objeto 'Parse' a un objeto 'Foundation'.
	
		- parameter results: los resultados obtenidos a través de la solicitud (un array de diccionarios)
	
		- returns: un array de objetos usables (Foundation) 'StudentInformation'
		*/
		static func allContactsFrom(_ results: [[String:AnyObject]]) -> [Contact] {
	
			var contact = [Contact]()
	
			// iterar a través de los resultados del array  donde cada 'StudentInformation' es un diccionario
			// de esta forma obtenemos un colección de objetos ´StudentInformation´ (no uno solo) al agregar cada objeto a la estructura ´StudentInformation´
			for result in results {
				contact.append(Contact(dictionary: result))
			}
	
			return contact
		}
	
		// la información de los contactos recibida y almancenada (lista para usar) 👏
		static var contactInformationStored = [Contact]()
	
	
}

