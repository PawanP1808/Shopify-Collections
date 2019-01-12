//
//  DataManager.swift
//  MyShopifyCollections
//
//  Created by Pawan Patel on 2019-01-10.
//  Copyright © 2019 PIM. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import UIKit

class DataManager {

	private let baseUrl = "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"

	private let productsUrlPrefix = "https://shopicruit.myshopify.com/admin/collects.json?collection_id="
	private let productsUrlSuffix = "&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"

	private let productsDataUrlPrefix = "https://shopicruit.myshopify.com/admin/products.json?ids="

	private let productsDetailsUrlSuffix = "&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"

	func getCollections( _success completion:@escaping (Bool,[Product]?)->()) {

		Alamofire.request(self.baseUrl, method: .get, encoding: JSONEncoding.default, headers:nil).responseJSON {
			response in
			guard let data = response.result.value as? [String:Any],let customCollectionsArray = data["custom_collections"] as? [[String:Any]]
				else {
					completion(false,nil)
					return
			}
			var products:[Product]? = []
			for productJson in customCollectionsArray{
				let product = Product(json: productJson)
				products?.append(product)
			}
			completion(true,products)
		}
	}

	func getProductIdsForCollection(id:Int, _success completion:@escaping (Bool,[Int]?)->()) {
		Alamofire.request(self.productsUrlPrefix + String(describing: id) + self.productsUrlSuffix, method: .get, encoding: JSONEncoding.default, headers:nil).responseJSON {
			response in
			guard let data = response.result.value as? [String:Any],let collectsArray = data["collects"] as? [[String:Any]]
				else {
					completion(false,nil)
					return
			}
			var ids:[Int] = []
			for collect in collectsArray{
				if let id = collect["product_id"] as? Int {
					ids.append(id)
				}
			}
			completion(true,ids)
		}
	}

	func getProductDataForIds( ids:[Int],_success completion:@escaping (Bool,[Product]?)->()) {
		var str = ""
		for id in ids {
			str += String(describing: id) + ","
		}
		Alamofire.request(self.productsDataUrlPrefix + str + self.productsDetailsUrlSuffix, method: .get, encoding: JSONEncoding.default, headers:nil).responseJSON {
			response in
			guard let data = response.result.value as? [String:Any], let productsArray = data["products"] as? [[String:Any]]
				else {
					completion(false,nil)
					return
			}
			var productData:[Product]? = []
			for productJson in productsArray{
				let product = Product(json: productJson)
				productData?.append(product)
			}
			completion(true,productData)
		}
	}

	func retrieveImage(forUrl url:String,_success completion:@escaping (Bool,UIImage?)->()){
		Alamofire.request(url).responseImage { response in
			guard let image = response.result.value else {
				completion(false,nil)
				return
			}
			completion(true,image)
		}
	}

}

