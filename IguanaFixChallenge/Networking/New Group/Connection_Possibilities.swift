//
//  Connection_Possibilities.swift
//  IguanaFixChallenge
//
//  Created by Luciano Schillagi on 06/08/2018.
//  Copyright © 2018 luko. All rights reserved.
//

struct ConnectionPossibilities {
	
	enum Connection {
		case none, wifi, cellular
	}
	
	var connection: Connection
}
