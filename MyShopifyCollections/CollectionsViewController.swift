//
//  ViewController.swift
//  MyShopifyCollections
//
//  Created by Pawan Patel on 2019-01-10.
//  Copyright © 2019 PIM. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class CollectionsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
	private let dataManager = DataManager.shared

	private var collectionsData:[Product]?

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
		cell.title.text = collection.title
		guard let imageUrl = collection.image?["src"] as? String else {
			return cell
		}

		Alamofire.request(imageUrl).responseImage { response in
			if let image = response.result.value {
				cell.collectionImage.image = image
			}
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
		return 55
	}

	func performSegueToVote(id:Int) {
		guard let productsVc = storyboard?.instantiateViewController(withIdentifier: "collectionProductsViewController") as? CollectionProductsViewController else { return }
		productsVc.collectionID = id
		navigationController?.pushViewController(productsVc, animated: true)
	}
}

