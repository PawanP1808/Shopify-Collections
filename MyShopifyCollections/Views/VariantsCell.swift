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

	func setupCell(withData data:[String:Any]) {
		guard let title = data["title"] as? String,
			let price = data["price"] as? String,
			let inventory =  data["inventory_quantity"] as? Int else { return  }
		self.title.text = title
		self.price.text = "$\(price)"
		self.inventory.text = "Inventory:\(inventory)"
	}
}
