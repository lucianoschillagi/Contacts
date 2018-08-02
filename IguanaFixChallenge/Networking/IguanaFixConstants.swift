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
	
		// request
		static let ApiURL = "https://private-d0cc1-iguanafixtest.apiary-mock.com/contacts"
		static let ApiScheme = "https"
		static let ApiHost = "private-d0cc1-iguanafixtest.apiary-mock.com"
		static let ApiPath = "/contacts"
		
		
		// response
		struct JSONResponseKeys {
			
			static let FirstName = "first_name"
			static let LastName = "last_name"
			static let Photo = "photo"
		}
		
		
	
	
}

