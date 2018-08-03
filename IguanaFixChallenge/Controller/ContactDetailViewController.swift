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
	@IBOutlet weak var firstNameLabel: UILabel!
	@IBOutlet weak var firstNameCompletedLabel: UILabel!
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
		func configureView() {
			if let detailContact = detailContact {
				if let firstNameLabelCompletedLabel = firstNameCompletedLabel, let contactPhoto = contactPhoto {
					firstNameCompletedLabel.text = detailContact.firstName
					contactPhoto.image = UIImage(named:detailContact.photo)
					
					print("😉\(firstNameCompletedLabel.text)\(detailContact.photo)")

				}
			}
		}
	
	
}

