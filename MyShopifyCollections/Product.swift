//
//  Product.swift
//  MyShopifyCollections
//
//  Created by Pawan Patel on 2019-01-10.
//  Copyright © 2019 PIM. All rights reserved.
//

import Foundation
class Product {

	var id:Int?

	var title:String?
	var bodyHtml:String?

	var image:[String:Any]?
	var variants:[[String:Any]]?


	init(json: [String:Any]) {
		self.id = json["id"] as? Int
		self.title = json["title"] as? String
		self.bodyHtml = json["body_html"] as? String
		self.image = json["image"] as? [String:Any] ?? nil
		let variants = json["variants"] as? [[String:Any]]
		self.variants = variants

	}
}
