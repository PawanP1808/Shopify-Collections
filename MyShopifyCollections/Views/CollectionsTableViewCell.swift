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

	func setupCell(withData collection:Collections) {
		let dataManager = DataManager()
		guard let unwrappedTitle = collection.title,let imageUrl = collection.imageUrl else { return }
		self.title.text = unwrappedTitle
		dataManager.retrieveImage(forUrl: imageUrl) { success,image in
			guard success,let unwrappedImage = image else { return }
			self.collectionImage.image = unwrappedImage
		}
	}

}
