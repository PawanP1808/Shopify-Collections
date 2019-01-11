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

	var collectionsData:[Product]?

	@IBOutlet weak var collectionsTableView: UITableView!
	override func viewDidLoad() {
		super.viewDidLoad()
		dataManager.getCollections() { success,data in
			if (success) {
				self.collectionsData = data
				self.collectionsTableView.reloadData()
				self.collectionsTableView.rowHeight = 55
			}

		}
		// Do any additional setup after loading the view, typically from a nib.
	}

	 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = collectionsTableView.dequeueReusableCell(withIdentifier: "collectionTableViewCell", for: indexPath as IndexPath) as! CollectionsTableViewCell
		let collection = collectionsData![indexPath.row]
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

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.collectionsTableView.deselectRow(at: indexPath, animated: true)
		let collection = collectionsData![indexPath.row]
		self.performSegueToVote(id:collection.id!)
	}


	func performSegueToVote(id:Int) {
		let myVC = storyboard?.instantiateViewController(withIdentifier: "collectionProductsViewController") as! CollectionProductsViewController

		myVC.collectionID = id
		navigationController?.pushViewController(myVC, animated: true)
	}
}

