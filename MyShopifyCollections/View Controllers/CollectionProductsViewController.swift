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

	var collectionData:Product?
	var dataManager:DataManager?

	@IBOutlet weak var productsTableView: UITableView!

	@IBOutlet weak var collectionImageView: UIImageView!


	@IBOutlet weak var headerView: UIView!

	@IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!

	@IBOutlet weak var headerViewTopConstraint: NSLayoutConstraint!

	@IBOutlet weak var collectionTitleLabel: UILabel!

	
	@IBOutlet weak var collectionDescriptionLabel: UILabel!


	@IBOutlet weak var descLabelHeightConstraint: NSLayoutConstraint!

	override func viewDidLoad() {
		self.dataManager = DataManager()
		self.setupHeader()
		self.retrieveTableData()
	}

	private func retrieveTableData(){
		self.activityIndicator = self.showSpinner()
		guard let collection = self.collectionData,let id = collection.id else { return }
		self.dataManager?.getProductIdsForCollection(id: id) { success,data in
			guard success,let unwrappedIds = data else { return }
			self.dataManager?.getProductDataForIds(ids: unwrappedIds){ success, data in
				guard success, let unwrappedData = data, self.setTableData(forData: unwrappedData) else { return }
				self.productsTableView.reloadData()
				self.hideModalSpinner(indicator: self.activityIndicator)
			}
		}

	}

	private func setupHeader() {
		guard let collection = self.collectionData else { return }
		if collection.bodyHtml == "" {
			self.headerView.frame = CGRect(x: 0, y: 0, width: self.headerView.frame.width, height: self.headerView.frame.height - self.collectionDescriptionLabel.frame.height)
			descLabelHeightConstraint.constant = 0
			self.headerView.layoutIfNeeded()
		} else {
			collectionDescriptionLabel.text = collection.bodyHtml
		}
		guard let imageUrl = collection.image?["src"] as? String else {
			return
		}
		dataManager?.retrieveImage(forUrl: imageUrl) {success,image in
			self.collectionImageView.image = image
		}
		collectionTitleLabel.text = collection.title
		self.productsTableView.contentInset = UIEdgeInsets(top: headerView.frame.height, left: 0, bottom: 0, right: 0)
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

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offset = scrollView.contentOffset.y
		if offset>headerView.frame.height - 10{
			headerViewTopConstraint.constant = headerView.frame.height + offset - 10
			headerView.layoutIfNeeded()
		} else if offset<0 {
			headerViewTopConstraint.constant = headerView.frame.height + offset - 10
			headerView.layoutIfNeeded()
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
