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
	var imageUrl:String?
	var variants = [Variants]()

	init(json: [String:Any]) {
		self.id = json["id"] as? Int
		self.title = json["title"] as? String
		self.bodyHtml = json["body_html"] as? String
		if let image = json["image"] as? [String:Any] {
			self.imageUrl = image["src"] as? String
		}
		guard let variants = json["variants"] as? [[String:Any]] else { return }
		for variant in variants {
			self.variants.append(Variants(json: variant))
		}
	}
}
