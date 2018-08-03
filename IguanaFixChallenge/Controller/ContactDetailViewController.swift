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
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var nameCompletedLabel: UILabel!
	@IBOutlet weak var phoneLabel: UILabel!
	@IBOutlet weak var phonoCompletedLabel: UILabel!
	
	//*****************************************************************
	// MARK: - Properties
	//*****************************************************************

		var detailContact: Contact? {
			didSet {
				configureView()
			}
		}
	
	
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
	
	// task: configurar las vistas
	func configureView() {
			if let detailContact = detailContact {
				if let nameCompletedLabel = nameCompletedLabel, let contactPhoto = contactPhoto {
					nameCompletedLabel.text = detailContact.firstName + " " + detailContact.lastName
					contactPhoto.image = UIImage(named:detailContact.photo)
					
					// create url
					let photoUrl = URL(string: detailContact.photo)!
					debugPrint("el url de la foto es \(photoUrl)")
					// create network request
					let task = URLSession.shared.dataTask(with: photoUrl) { (data, response, error) in
						debugPrint("data: \(data), response \(response), error \(error)")
						if error == nil {
							debugPrint("los datos de la foto son \(data)")
							// create image
							let downloadedImage = UIImage(data: data!)
							debugPrint("🚀\(downloadedImage)")
							self.contactPhoto.image = downloadedImage
							// update UI on a main thread
							DispatchQueue.main.async {
								
								//self.contactPhoto.image = downloadedImage
								
							}
							
						} else {
							print(error!)
						}
						print(data)
					}
					
					// start network request
					task.resume()

				}
			}
		}
	
	
}

