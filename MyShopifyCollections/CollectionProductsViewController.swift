//
//  CollectionProductsViewController.swift
//  MyShopifyCollections
//
//  Created by Pawan Patel on 2019-01-10.
//  Copyright © 2019 PIM. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

struct cellData {
 var opened = Bool()
	var title = String()
	var total = String()
	var description = String()
	var imageUrl = String()
	var sectionData = [[String:Any]]()
}

class CollectionProductsViewController:UIViewController,UITableViewDelegate,UITableViewDataSource {

	private let dataManager = DataManager.shared

	@IBOutlet weak var productsTableView: UITableView!

	var collectionID:Int?

	var collectionsData:[Product]?

	var tableViewData = [cellData]()


	override func viewDidLoad() {

		self.productsTableView.rowHeight = 60

//		self.tableViewData = [cellData(opened: false, title: "title1", sectionData: ["cell1","cell2","cell3"]),
//					  cellData(opened: false, title: "title1", sectionData: ["cell1","cell2","cell3"]),
//					  cellData(opened: false, title: "title1", sectionData: ["cell1","cell2","cell3"])]

//		print(self.collectionID)
		dataManager.getProductIdsForCollection(id: self.collectionID!) { success,data in
			if (success) {
				self.dataManager.getProductDataForIds(ids: data!){ success, data in

					self.collectionsData = data
					self.productsTableView.reloadData()
					self.productsTableView.rowHeight = 100

					for product in self.collectionsData! {
						var total = 0
								for variants in product.variants! {
									let inventory = variants["inventory_quantity"] as! Int
									total += inventory

								}

						
						self.tableViewData.append(cellData(opened: false, title: product.title!,total:"Total Inventory: \(total)",description: product.bodyHtml!,imageUrl:product.image!["src"] as! String, sectionData: product.variants!))


					}
					self.productsTableView.reloadData()

				}
			}

		}
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		dump(tableViewData.count)
		return tableViewData.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableViewData[section].opened == true {
			return tableViewData[section].sectionData.count + 1

		} else {
			return 1
		}
	}

	 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = productsTableView.dequeueReusableCell(withIdentifier: "productsTableViewCell", for: indexPath as IndexPath) as! ProductsTableViewCell

			cell.title.text = tableViewData[indexPath.section].title
					cell.totalLabel.text = tableViewData[indexPath.section].description
					cell.collectionTitleLabel.text = tableViewData[indexPath.section].total
			Alamofire.request(tableViewData[indexPath.section].imageUrl).responseImage { response in
							if let image = response.result.value {
								cell.productImage.image = image
							}
						}
			cell.separatorInset = .zero
			return cell
		} else {
			let cell = productsTableView.dequeueReusableCell(withIdentifier: "variantsCell", for: indexPath as IndexPath) as! VariantsCell
			cell.title.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]["title"] as? String
			cell.price.text = "$\(tableViewData[indexPath.section].sectionData[indexPath.row - 1]["price"] as! String)"
			cell.inventory.text = "Inventory:\(String(describing: tableViewData[indexPath.section].sectionData[indexPath.row - 1]["inventory_quantity"] as! Int))"
			cell.accessoryType = .none
//			Alamofire.request(tableViewData[indexPath.section].sectionData[indexPath.row - 1]).responseImage { response in
//				if let image = response.result.value {
//					cell.productImage.image = image
//				}
//			}
			return cell
		}

	}

	 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableViewData[indexPath.section].opened == true {
			tableViewData[indexPath.section].opened = false
			let sections = IndexSet.init(integer: indexPath.section)
			productsTableView.reloadSections(sections, with: .none)
		} else {
			tableViewData[indexPath.section].opened = true
			let sections = IndexSet.init(integer: indexPath.section)
			productsTableView.reloadSections(sections, with: .none)
		}

	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return 80
		} else {
			return 30
		}
	}







//
//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let cell = productsTableView.dequeueReusableCell(withIdentifier: "productsTableViewCell", for: indexPath as IndexPath) as! ProductsTableViewCell
//		let collection = collectionsData![indexPath.row]
//		cell.title.text = collection.title
//		cell.totalLabel.text = "Total Inventory: \(self.getTotalInventory(ForProduct: indexPath.row))"
//		cell.collectionTitleLabel.text = collection.title
//
//
//		guard let imageUrl = collection.image?["src"] as? String else {
//			return cell
//		}
//
//		Alamofire.request(imageUrl).responseImage { response in
//			if let image = response.result.value {
//				cell.productImage.image = image
//			}
//		}
//
//		return cell
//	}
//
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		guard let count = self.collectionsData?.count else {
//			return 0
//		}
//		return count
//	}
//
//
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		//		let collection = collectionsData![indexPath.row]
//		//		self.performSegueToVote(id:collection.id!)
//		navigationController?.popViewController(animated: false)
//	}
//
//	func performSegueToVote(id:Int) {
//		let myVC = storyboard?.instantiateViewController(withIdentifier: "collectionProductsViewController") as! CollectionProductsViewController
//
//		myVC.collectionID = id
//		navigationController?.pushViewController(myVC, animated: true)
//	}
//
//	private func getTotalInventory(ForProduct position:Int)->Int {
//		let product = self.collectionsData![position]
//		var total = 0
//		for variants in product.variants! {
//			let inventory = variants["inventory_quantity"] as! Int
//			total += inventory
//
//		}
//		return total
//
//	}




}
