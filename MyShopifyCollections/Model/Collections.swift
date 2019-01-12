//
//  Collections.swift
//  MyShopifyCollections
//
//  Created by Pawan Patel on 2019-01-10.
//  Copyright © 2019 PIM. All rights reserved.
//

import Foundation


class Collections {

	var data:[Product]?

	init(json: [[String:Any]]) {
		for data1 in json{
			let product = Product(json: data1)
			self.data?.append(product)
		}
	}
}
