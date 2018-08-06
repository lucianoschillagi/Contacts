//
//  ContactVC_Helpers.swift
//  IguanaFixChallenge
//
//  Created by Luciano Schillagi on 06/08/2018.
//  Copyright © 2018 luko. All rights reserved.
//

import Foundation

extension ContactsViewController {
	
	//*****************************************************************
	// MARK: - Search Controller & Filtering Methods
	//*****************************************************************
	
	// task: configurar al controlador de búsqueda
	func setupSearchController() {
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Contacts"
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}
	
	// task: notificar si la barra de búsqueda está vacía o no.
	func searchBarIsEmpty() -> Bool {
		// Returns true if the text is empty or nil
		return searchController.searchBar.text?.isEmpty ?? true
	}
	
	// task: determinar si actualmente se están filtrando resultados o no
	func isFiltering() -> Bool {
		//debugPrint("🏋🏻‍♂️\(searchController.isActive && !searchBarIsEmpty())")
		return searchController.isActive && !searchBarIsEmpty()
	}
	
	// task: filtrar contenido según el texto de búsqueda 👏
	func filterContentForSearchText(_ searchText: String) {
		// pone los contactos filtrados en el array 'filteredContacts'
		filteredContacts = allContacts.filter({( contact : Contact) -> Bool in
			return contact.firstName.lowercased().contains(searchText.lowercased())
		})
		tableView.reloadData()
		debugPrint("Los contactos filtrados actualmente son: \(filteredContacts)")
	}
	
	// task: rellenar la propiedad 'contactNames' con los nombres de todos los contactos 👏
	func getContactNames() {
		
		// si está fitrando...
		if isFiltering() {
			
			for filteredContactName in self.filteredContacts {
				let fullName = filteredContactName.lastName + " " + filteredContactName.firstName
				self.filteredContactNames.append(fullName)
				debugPrint("Este es el listado de los nombres filtrados: \(self.filteredContactNames)")
			}
			
			// si NO está filtrando
		} else {
			
			for contactName in self.allContacts {
				let fullName = contactName.lastName + " " + contactName.firstName
				self.contactNames.append(fullName)
				debugPrint("🍎 Este es el listado de los nombres completos: \(self.contactNames)")
			}
		}
		
		getInitialOfTheNames()
	}
	
	// task: obtener las iniciales de los nombres de los contactos
	func getInitialOfTheNames() {
		
		// para luego indexar la tabla
		// itera el array 'contact names'
		for name in self.contactNames {
			// extrae la inicial de cada nombre
			let nameKey = String(name.prefix(1))
			// y se usa como clave de ´contactNamesDictionary´
			if var nameValues = contactNamesDictionary[nameKey] {
				// 2-o si la clave ya existe, agrega ese nuevo nombre al array
				nameValues.append(name)
				contactNamesDictionary[nameKey] = nameValues
			} else {
				// 1-con esta clave se crea una nueva serie de nombres
				contactNamesDictionary[nameKey] = [name]
			}
			
		}
		debugPrint("😛\(self.contactNamesDictionary)")
		// asigna las claves de cada sección a las claves de cada uno de los elementos del diccionario 🔌
		conctactNamesSectionTitles = [String](contactNamesDictionary.keys)
		conctactNamesSectionTitles = conctactNamesSectionTitles.sorted(by: { $0 < $1 })
		debugPrint("contact names dictionary: \(contactNamesDictionary)")
		
	}
	
	//*****************************************************************
	// MARK: - Activity Indicator
	//*****************************************************************
	
	func startActivityIndicator() {
		activityIndicator.alpha = 1.0
		activityIndicator.startAnimating()
	}
	
	func stopActivityIndicator() {
		self.activityIndicator.alpha = 0.0
		self.activityIndicator.stopAnimating()
	}
	
}
