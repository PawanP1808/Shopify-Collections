//
//  ViewController.swift
//  MyShopifyCollections
//
//  Created by Pawan Patel on 2019-01-10.
//  Copyright © 2019 PIM. All rights reserved.
//

import UIKit

class CollectionsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
	private let dataManager = DataManager.shared

	private var collectionsData:[Product]?

	private let collectionsCellHeight = CGFloat(integerLiteral: 55)

	@IBOutlet weak var collectionsTableView: UITableView!
	override func viewDidLoad() {
		super.viewDidLoad()
		dataManager.getCollections() { success,data in
			if (success) {
				self.collectionsData = data
				self.collectionsTableView.reloadData()
			}

		}
	}

	 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = collectionsTableView.dequeueReusableCell(withIdentifier: "collectionTableViewCell", for: indexPath as IndexPath) as? CollectionsTableViewCell else {
			return UITableViewCell()
		}
		guard let unwrappedCollection = collectionsData else { return cell }
		let collection = unwrappedCollection[indexPath.row]
		guard let unwrappedTitle = collection.title else { return cell}
		cell.setupCell(title: unwrappedTitle)
		guard let imageUrl = collection.image?["src"] as? String else {
			return cell
		}
		dataManager.retrieveImage(forUrl: imageUrl) { success,image in
			guard success,let unwrappedImage = image else { return }
			cell.setCellImage(forImage: unwrappedImage)
		}
		return cell
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
		self.performSegueToVote(id: id)
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return self.collectionsCellHeight
	}

	func performSegueToVote(id:Int) {
		guard let productsVc = storyboard?.instantiateViewController(withIdentifier: "collectionProductsViewController") as? CollectionProductsViewController else { return }
		productsVc.collectionID = id
		navigationController?.pushViewController(productsVc, animated: true)
	}
}

