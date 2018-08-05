//
//  IguanaFixConstants.swift
//  IguanaFixChallenge
//
//  Created by Luciano Schillagi on 26/07/2018.
//  Copyright © 2018 luko. All rights reserved.
//

/* Networking */

import Foundation

/* Abstract:
Almacena...
*/

extension IguanaFixClient {
	
	//*****************************************************************
	// MARK: - Resquest
	//*****************************************************************
		static let ApiURL = "https://private-d0cc1-iguanafixtest.apiary-mock.com/contacts"
		static let ApiScheme = "https"
		static let ApiHost = "private-d0cc1-iguanafixtest.apiary-mock.com"
		static let ApiPath = "/contacts"
	
	//*****************************************************************
	// MARK: - Response
	//*****************************************************************
		struct JSONResponseKeys {
			static let UserID = "user_id"
			static let CreatedAt = "created_at"
			static let BirthDate = "birth_date"
			static let FirstName = "first_name"
			static let LastName = "last_name"
			static let PhonoType = "type"
			static let PhonoNumber = "number"
			static let Thumb = "thumb"
			static let Photo = "photo"
		}
	
}

