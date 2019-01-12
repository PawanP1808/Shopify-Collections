//
//  ProductsTableViewCell.swift
//  MyShopifyCollections
//
//  Created by Pawan Patel on 2019-01-10.
//  Copyright © 2019 PIM. All rights reserved.
//

import Foundation
import UIKit

struct cellData {
	var opened = Bool()
	var title = String()
	var total = String()
	var description = String()
	var imageUrl = String()
	var sectionData = [[String:Any]]()
}

class ProductsTableViewCell: UITableViewCell {

	@IBOutlet weak var productImage: UIImageView!

	@IBOutlet weak var title: UILabel!

	@IBOutlet weak var totalLabel: UILabel!
	
	@IBOutlet weak var collectionTitleLabel: UILabel!

	func setupCell(withData data:cellData) {
		let dataManager = DataManager()
		self.title.text = data.title
		self.totalLabel.text = data.description
		self.collectionTitleLabel.text = data.total
		dataManager.retrieveImage(forUrl: data.imageUrl) { success,image in
			guard success,let unwrappedImage = image else { return }
			self.productImage.image = unwrappedImage
		}
	}
}
