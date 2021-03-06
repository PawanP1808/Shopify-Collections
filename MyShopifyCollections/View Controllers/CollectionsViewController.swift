//
//  CollectionsViewController.swift
//  MyShopifyCollections
//
//  Created by Pawan Patel on 2019-01-10.
//  Copyright © 2019 PIM. All rights reserved.
//

import UIKit

class CollectionsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

	// MARK: -- IBOutlets
	@IBOutlet weak var collectionsTableView: UITableView!
	
	@IBOutlet weak var noResultsLabel: UILabel!
	
	@IBOutlet weak var searchBar: UISearchBar!
	
	// MARK: -- Properties
	private var collectionsData:[Collections]?
	private var currentCollectionsData:[Collections]?
	private let collectionsCellHeight = CGFloat(integerLiteral: 55)
	private let collectionCellIdentifier = "collectionTableViewCell"
	private let collectionsProductViewController = "collectionProductsViewController"
	private var activityIndicator:UIActivityIndicatorView? = nil

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupTableView()
		self.retrieveTableData()
	}

	private func retrieveTableData() {
		self.activityIndicator = self.showSpinner()
		let dataManager = DataManager()
		dataManager.getCollections() { success,data in
			guard success else { return }
			self.collectionsData = data
			self.currentCollectionsData = data
			self.collectionsTableView.reloadData()
			self.hideModalSpinner(indicator: self.activityIndicator)
		}
	}

	private func setupTableView(){
		let insets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
		self.collectionsTableView.contentInset = insets
	}

	//MARK:TABLEVIEW DELEGATES
	 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let collectionCell = collectionsTableView.dequeueReusableCell(withIdentifier: self.collectionCellIdentifier, for: indexPath as IndexPath) as? CollectionsTableViewCell else {
			return UITableViewCell()
		}
		guard let unwrappedCollection = currentCollectionsData else { return collectionCell }
		let collection = unwrappedCollection[indexPath.row]
		collectionCell.setupCell(withData: collection)
		return collectionCell
	}

	 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let count = self.currentCollectionsData?.count else {
			return 0
		}
		return count
	}

	 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.collectionsTableView.deselectRow(at: indexPath, animated: true)
		guard let unwrappedCollection = currentCollectionsData else { return }
		let collection = unwrappedCollection[indexPath.row]
		self.performSegueToCollectionProducts(withData: collection)
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return self.collectionsCellHeight
	}

	//MARK: SEARCHBAR DELEGATE
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		guard let collectionData = collectionsData else { return }
		currentCollectionsData = collectionData.filter({ collection -> Bool in
			if searchText.isEmpty { return true }
			guard let title = collection.title?.lowercased() else { return true }
			return title.contains(searchText.lowercased())
		})
		if currentCollectionsData?.count == 0 {
			self.noResultsLabel.isHidden = false
		} else {
			self.noResultsLabel.isHidden = true
		}
		collectionsTableView.reloadData()
	}

	//MARK -- SCROLL(TABLE) VIEW DELEGATES

	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		if scrollView == collectionsTableView {
			searchBar.resignFirstResponder()
		}
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView == collectionsTableView {
			searchBar.resignFirstResponder()
		}
	}

	//MARK: SEGUE TO COLLECTION PRODUCTS
	func performSegueToCollectionProducts(withData collectionData:Collections) {
		guard let productsVc = storyboard?.instantiateViewController(withIdentifier: self.collectionsProductViewController) as? CollectionProductsViewController else { return }
		productsVc.collectionData = collectionData
		navigationController?.pushViewController(productsVc, animated: true)
	}
}

