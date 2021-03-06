//
//  VariantsCell.swift
//  MyShopifyCollections
//
//  Created by Pawan Patel on 2019-01-11.
//  Copyright © 2019 PIM. All rights reserved.
//

import Foundation
import UIKit

class VariantsCell: UITableViewCell {

	@IBOutlet weak var title: UILabel!

	@IBOutlet weak var price: UILabel!

	@IBOutlet weak var inventory: UILabel!

	func setupCell(withData data:Variants) {
		self.title.text = data.title
		if let price = data.price{
			self.price.text = "$\(price)"
		}
		self.inventory.text = "Inventory:\(data.inventory ?? 0)"
	}
}
