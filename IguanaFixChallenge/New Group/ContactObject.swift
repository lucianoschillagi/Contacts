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
	
	
	//*****************************************************************
	// MARK: - Properties
	//*****************************************************************
	
	let userID: String
	let createdAt: String
	let birthDate: String
	let firstName: String
	let lastName: String
	var phones: [[String:AnyObject]]
	var phonoType: String?
	var phonoNumber: String?
	var thumb: String?
	var photo: String?
	
	//*****************************************************************
	// MARK: - Initializers
	//*****************************************************************
	
	// task: construir el objeto 'Contact' desde un diccionario (el JSON obtenido '[String:AnyObject]')
	init(dictionary: [String:AnyObject]) {
		// user id
		userID = dictionary[IguanaFixClient.JSONResponseKeys.UserID] as! String
		// created at
		createdAt = dictionary[IguanaFixClient.JSONResponseKeys.CreatedAt] as! String
		// birth date
		birthDate = dictionary[IguanaFixClient.JSONResponseKeys.BirthDate] as! String
		// first name
		firstName = dictionary[IguanaFixClient.JSONResponseKeys.FirstName] as! String
		// last name
		lastName = dictionary[IguanaFixClient.JSONResponseKeys.LastName] as! String
		// phones
		phones = dictionary["phones"] as! [Dictionary]
		
		// phono type
		if let phonesString = dictionary["phones"] as? [[String:AnyObject]] {
			phones = phonesString
			} else {
			phones = [[:]]
			}
		
		// phono number
//		if let phonoNumberString = phones["number"] as? String {
//			phonoNumber = phonoNumberString["number"] as! String
//		} else {
//			phonoNumber = ""
//		}

		// thumb
		if let thumbString = dictionary[IguanaFixClient.JSONResponseKeys.Thumb] as? String {
			thumb = thumbString
		} else {
			thumb = ""
		}

		// photo
		if let photoString = dictionary[IguanaFixClient.JSONResponseKeys.Photo] as? String {
			photo = photoString
		} else {
			photo = ""
		}

	}
	
	//*****************************************************************
	// MARK: - Methods
	//*****************************************************************
	
	// task: transformar al resultado obtenido (array de objetos JSON) en un array de objetos Foundation 'Contacto'
	static func contactsFromResults(_ results: [[String:AnyObject]]) -> [Contact] {
		
		var contacts = [Contact]()
		
		// iterate through array of dictionaries, each Movie is a dictionary
		for result in results {
			contacts.append(Contact(dictionary: result))
		}
		
		return contacts
	}
	
	static var allContacts: [Contact] = [Contact]()
}


