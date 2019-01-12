//
//  CollectionsTableViewCell.swift
//  MyShopifyCollections
//
//  Created by Pawan Patel on 2019-01-10.
//  Copyright © 2019 PIM. All rights reserved.
//

import Foundation
import UIKit

class CollectionsTableViewCell: UITableViewCell {

	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var collectionImage: UIImageView!

	func setupCell(withData collection:Product) {

		let dataManager = DataManager()
		guard let unwrappedTitle = collection.title else { return }
		self.title.text = unwrappedTitle
		guard let imageUrl = collection.image?["src"] as? String else {
			return 
		}
		dataManager.retrieveImage(forUrl: imageUrl) { success,image in
			guard success,let unwrappedImage = image else { return }
			self.collectionImage.image = unwrappedImage
		}
	}

}
