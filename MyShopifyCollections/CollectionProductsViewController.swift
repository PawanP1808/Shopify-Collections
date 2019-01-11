//
//  CollectionProductsViewController.swift
//  MyShopifyCollections
//
//  Created by Pawan Patel on 2019-01-10.
//  Copyright © 2019 PIM. All rights reserved.
//

import Foundation
import UIKit

class CollectionProductsViewController:UIViewController,UITableViewDelegate,UITableViewDataSource {

	private let dataManager = DataManager.shared
	private let productsCellHeight = CGFloat(integerLiteral: 80)
	private let variantsCellHeight = CGFloat(integerLiteral: 30)

	private var tableViewData = [cellData]()

	@IBOutlet weak var productsTableView: UITableView!

	var collectionID:Int?

	override func viewDidLoad() {
		guard let id = collectionID else {return}
		dataManager.getProductIdsForCollection(id: id) { success,data in
			guard success,let unwrappedIds = data else { return }
				self.dataManager.getProductDataForIds(ids: unwrappedIds){ success, data in
					guard success, let unwrappedData = data, self.setTableData(forData: unwrappedData) else { return }
					self.productsTableView.reloadData()
				}

		}
	}

	func numberOfSections(in tableView: UITableView) -> Int {
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
			guard let cell = productsTableView.dequeueReusableCell(withIdentifier: "productsTableViewCell", for: indexPath as IndexPath) as? ProductsTableViewCell else { return UITableViewCell() }
			cell.setupCell(withData: tableViewData[indexPath.section])
			dataManager.retrieveImage(forUrl: tableViewData[indexPath.section].imageUrl) { success,image in
				guard success,let unwrappedImage = image else { return }
				cell.setCellImage(forImage: unwrappedImage)
			}
			return cell
		} else {
			guard let cell = productsTableView.dequeueReusableCell(withIdentifier: "variantsCell", for: indexPath as IndexPath) as? VariantsCell else { return UITableViewCell() }
			guard let title = tableViewData[indexPath.section].sectionData[indexPath.row - 1]["title"] as? String,
				let price = tableViewData[indexPath.section].sectionData[indexPath.row - 1]["price"] as? String,
				let inventory =  tableViewData[indexPath.section].sectionData[indexPath.row - 1]["inventory_quantity"] as? Int else { return cell}
			cell.setupCell(title: title, price: price, inventory: inventory)
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
			return self.productsCellHeight
		} else {
			return self.variantsCellHeight
		}
	}

	private func setTableData(forData data:[Product])-> Bool {
		for product in data {
			var total = 0
			guard let variants = product.variants else { return false }
			for variant in variants {
				guard let quantity = variant["inventory_quantity"] as? Int else {return false}
				total += quantity
			}
			guard let title = product.title, let description = product.bodyHtml, let image = product.image,let imageUrl = image["src"] as? String else { return false }
			self.tableViewData.append(cellData(opened: false, title: title,total:"Total Inventory: \(total)",description: description,imageUrl: imageUrl, sectionData: variants))
		}
		return true
	}

}
