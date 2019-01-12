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

	private let productsCellHeight = CGFloat(integerLiteral: 80)
	private let variantsCellHeight = CGFloat(integerLiteral: 30)
	private let productsTableViewCellIdentifier = "productsTableViewCell"
	private let variantsCellIdentifier = "variantsCell"


	private var tableViewData = [cellData]()
	private var activityIndicator:UIActivityIndicatorView? = nil

	var collectionID:Int?

	@IBOutlet weak var productsTableView: UITableView!


	override func viewDidLoad() {
		self.activityIndicator = self.showSpinner()
		guard let id = collectionID else {return}
		let dataManager = DataManager()
		dataManager.getProductIdsForCollection(id: id) { success,data in
			guard success,let unwrappedIds = data else { return }
				dataManager.getProductDataForIds(ids: unwrappedIds){ success, data in
					guard success, let unwrappedData = data, self.setTableData(forData: unwrappedData) else { return }
					self.productsTableView.reloadData()
					self.hideModalSpinner(indicator: self.activityIndicator)
				}
		}
	}

	//MARK:TABLEVIEW DELEGATES
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
			guard let productCell = productsTableView.dequeueReusableCell(withIdentifier: self.productsTableViewCellIdentifier, for: indexPath as IndexPath) as? ProductsTableViewCell else { return UITableViewCell() }
			productCell.setupCell(withData: tableViewData[indexPath.section])
			return productCell
		} else {
			guard let variantCell = productsTableView.dequeueReusableCell(withIdentifier: self.variantsCellIdentifier, for: indexPath as IndexPath) as? VariantsCell else { return UITableViewCell() }
			variantCell.setupCell(withData:  tableViewData[indexPath.section].sectionData[indexPath.row - 1])
			return variantCell
		}
	}

	 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let sections = IndexSet.init(integer: indexPath.section)
		if tableViewData[indexPath.section].opened == true {
			tableViewData[indexPath.section].opened = false
		} else {
			tableViewData[indexPath.section].opened = true
		}
		productsTableView.reloadSections(sections, with: .none)
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return self.productsCellHeight
		} else {
			return self.variantsCellHeight
		}
	}

	//MARK: SETUP PRODUCTS TABLE DATA
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
