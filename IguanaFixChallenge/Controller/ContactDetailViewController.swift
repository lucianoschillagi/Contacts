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
	@IBOutlet weak var lastName: UILabel!
	@IBOutlet weak var lastNameCompleted: UILabel!
	@IBOutlet weak var adressLabel: UILabel!
	@IBOutlet weak var adressCompletedLabel: UILabel!
	@IBOutlet weak var phoneLabel: UILabel!
	@IBOutlet weak var phonoCompletedLabel: UILabel!
	
	//*****************************************************************
	// MARK: - Properties
	//*****************************************************************
		// var movie: TMDBMovie?
		var contact: [[String:Any]] = []

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
//			if let detailCandy = detailCandy {
//				if let detailDescriptionLabel = detailDescriptionLabel, let candyImageView = candyImageView {
//					detailDescriptionLabel.text = detailCandy.name
//					candyImageView.image = UIImage(named: detailCandy.name)
//					title = detailCandy.category
//				}
//			}
		}
	
	
}

//class DetailViewController: UIViewController {
//
//	@IBOutlet weak var detailDescriptionLabel: UILabel!
//	@IBOutlet weak var candyImageView: UIImageView!
//
//	var detailCandy: Candy? {
//		didSet {
//			configureView()
//		}
//	}
//
//	func configureView() {
//		if let detailCandy = detailCandy {
//			if let detailDescriptionLabel = detailDescriptionLabel, let candyImageView = candyImageView {
//				detailDescriptionLabel.text = detailCandy.name
//				candyImageView.image = UIImage(named: detailCandy.name)
//				title = detailCandy.category
//			}
//		}
//	}
//
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		configureView()
//	}
//
//	override func didReceiveMemoryWarning() {
//		super.didReceiveMemoryWarning()
//	}
//
//}
