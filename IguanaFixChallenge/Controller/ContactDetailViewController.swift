//
//  ContactDetailViewController.swift
//  IguanaFixChallenge
//
//  Created by Luciano Schillagi on 30/07/2018.
//  Copyright © 2018 luko. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
	
	//*****************************************************************
	// MARK: - IBOutlets
	//*****************************************************************
	
	@IBOutlet weak var contactPhoto: UIImageView!
	@IBOutlet weak var userIdLabel: UILabel!
	@IBOutlet weak var userIdValueLabel: UILabel!
	@IBOutlet weak var createAtLabel: UILabel!
	@IBOutlet weak var createdAtValueLabel: UILabel!
	@IBOutlet weak var birthDateLabel: UILabel!
	@IBOutlet weak var birthDateValueLabel: UILabel!
	@IBOutlet weak var firstNameLabel: UILabel!
	@IBOutlet weak var firstNameValueLabel: UILabel!
	@IBOutlet weak var lastNameLabel: UILabel!
	@IBOutlet weak var lastNameValueLabel: UILabel!
	@IBOutlet weak var phonoTypeLabel: UILabel!
	@IBOutlet weak var phonoTypeValueLabel: UILabel!
	@IBOutlet weak var phonoNumberLabel: UILabel!
	@IBOutlet weak var phonoNumberValueLabel: UILabel!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	//*****************************************************************
	// MARK: - Properties
	//*****************************************************************

		var detailContact: Contact?
	
	//*****************************************************************
	// MARK: - VC Lifecycle
	//*****************************************************************
	override func viewDidLoad() {
		super.viewDidLoad()
		configureView()
	}
	
	//*****************************************************************
	// MARK: - Methods
	//*****************************************************************
	
	// task: configurar las vistas con los datos obtenidos en la solicitud web ('Contact' object)
	func configureView() {
		
		if let detailContact = detailContact {
				if let contactPhoto = contactPhoto, let userIdValueLabel = userIdValueLabel, let createdIdValueLabel = createdAtValueLabel, let birthDateValueLabel = birthDateValueLabel, let firstNameValueLabel = firstNameValueLabel, let lastNameValueLabel = lastNameValueLabel, let phonoTypeValueLabel = phonoTypeValueLabel, let phonoNumberValueLabel = phonoNumberValueLabel {
					
					userIdValueLabel.text = detailContact.userID
					createdIdValueLabel.text = detailContact.createdAt
					birthDateValueLabel.text = detailContact.birthDate
					firstNameValueLabel.text = detailContact.firstName
					lastNameValueLabel.text = detailContact.lastName
					phonoTypeValueLabel.text = detailContact.phonoType
					phonoNumberValueLabel.text = detailContact.phonoNumber
	
					contactPhoto.image = UIImage(named:detailContact.thumb!)
					let thumbUrl = URL(string: detailContact.thumb!)!
					let task = URLSession.shared.dataTask(with: thumbUrl) { (data, response, error) in
						self.startActivityIndicator()
						if error == nil {
							let downloadedImage = UIImage(data: data!)
							DispatchQueue.main.async {
								self.contactPhoto.image = downloadedImage
								self.stopActivityIndicator()
							}
							
						} else {
							print(error!)
						}
					}
					
					// start network request
					task.resume()

				}
			}
		}
	
	
	//*****************************************************************
	// MARK: - Helper methods
	//*****************************************************************
	
	func startActivityIndicator() {
		DispatchQueue.main.async {
			self.activityIndicator.alpha = 1.0
			self.activityIndicator.startAnimating()
		}
	}
	
	func stopActivityIndicator() {
		DispatchQueue.main.async {
			self.activityIndicator.alpha = 0.0
			self.activityIndicator.stopAnimating()
		}
	}
	
} // end class

