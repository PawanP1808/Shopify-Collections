//
//  Variants.swift
//  MyShopifyCollections
//
//  Created by Pawan Patel on 2019-01-13.
//  Copyright © 2019 PIM. All rights reserved.
//

import Foundation
class Variants {

	var title:String?
	var price:String?
	var inventory:Int?

	init(json: [String:Any]) {
		guard let title = json["title"] as? String,
			let price = json["price"] as? String,
			let inventory =  json["inventory_quantity"] as? Int else { return }
		self.title = title
		self.price = price
		self.inventory = inventory
	}
}
