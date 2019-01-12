//
//  CollectionsViewController.swift
//  MyShopifyCollections
//
//  Created by Pawan Patel on 2019-01-10.
//  Copyright © 2019 PIM. All rights reserved.
//

import UIKit

class CollectionsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

	private var collectionsData:[Product]?

	private let collectionsCellHeight = CGFloat(integerLiteral: 55)

	private let collectionCellIdentifier = "collectionTableViewCell"

	private let collectionsProductViewController = "collectionProductsViewController"

	private var activityIndicator:UIActivityIndicatorView? = nil

	@IBOutlet weak var collectionsTableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()
		self.activityIndicator = self.showSpinner()
		let dataManager = DataManager()
		dataManager.getCollections() { success,data in
			guard success else { return }
				self.collectionsData = data
				self.collectionsTableView.reloadData()
			self.hideModalSpinner(indicator: self.activityIndicator)
		}
	}

	//MARK:TABLEVIEW DELEGATES
	 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let collectionCell = collectionsTableView.dequeueReusableCell(withIdentifier: self.collectionCellIdentifier, for: indexPath as IndexPath) as? CollectionsTableViewCell else {
			return UITableViewCell()
		}
		guard let unwrappedCollection = collectionsData else { return collectionCell }
		let collection = unwrappedCollection[indexPath.row]
		collectionCell.setupCell(withData: collection)
		return collectionCell
	}

	 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let count = self.collectionsData?.count else {
			return 0
		}
		return count
	}

	 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.collectionsTableView.deselectRow(at: indexPath, animated: true)
		guard let unwrappedCollection = collectionsData else { return }
		let collection = unwrappedCollection[indexPath.row]
		guard let id = collection.id else { return }
		self.performSegueToCollectionProducts(id: id)
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return self.collectionsCellHeight
	}

	//MARK: SEGUE TO COLLECTION PRODUCTS
	func performSegueToCollectionProducts(id:Int) {
		guard let productsVc = storyboard?.instantiateViewController(withIdentifier: self.collectionsProductViewController) as? CollectionProductsViewController else { return }
		productsVc.collectionID = id
		navigationController?.pushViewController(productsVc, animated: true)
	}
}

