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


//let firstName: String
//let lastName: String
//let photo: String?
//let phone: String?

import Foundation


// MARK: - TMDBMovie

struct Contact {
	
	// MARK: Properties
	
	let firstName: String
	let lastName: String
	let photo: String
	//let phone: String?
	
	// MARK: Initializers
	
	// construct a TMDBMovie from a dictionary
	init(dictionary: [String:AnyObject]) {
		firstName = dictionary[IguanaFixClient.JSONResponseKeys.FirstName] as! String
		lastName = dictionary[IguanaFixClient.JSONResponseKeys.LastName] as! String
		photo = dictionary[IguanaFixClient.JSONResponseKeys.Photo] as! String
		
//		if let photoUrl = dictionaryIguanaFixClient.JSONResponseKeys.Photo] {
//			photo = photoUrl
//		} else {
//			photo = ""
//		}
		
	}
	
	static func contactsFromResults(_ results: [[String:AnyObject]]) -> [Contact] {
		
		var contacts = [Contact]()
		
		// iterate through array of dictionaries, each Movie is a dictionary
		for result in results {
			contacts.append(Contact(dictionary: result))
		}
		
		return contacts
	}
}


