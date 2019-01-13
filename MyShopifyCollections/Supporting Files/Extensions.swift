//
//  Extensions.swift
//  MyShopifyCollections
//
//  Created by Pawan Patel on 2019-01-11.
//  Copyright © 2019 PIM. All rights reserved.
//

import Foundation
import UIKit

// MARK: -- Handles showing spinner while data is being retieved from server
extension UIViewController {
	
	func showSpinner() ->UIActivityIndicatorView{
		UIApplication.shared.beginIgnoringInteractionEvents() // user cannot interact with the app while the spinner is visible
		let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
		actInd.frame = self.view.frame
		actInd.center = self.view.center
		actInd.hidesWhenStopped = true
		actInd.style = UIActivityIndicatorView.Style.whiteLarge
		self.view.addSubview(actInd)
		actInd.startAnimating()
		return actInd
	}

	func hideModalSpinner(indicator: UIActivityIndicatorView?){
		guard let unwrappedIndicator = indicator else { return }
		unwrappedIndicator.stopAnimating()
		unwrappedIndicator.isHidden = true
		UIApplication.shared.endIgnoringInteractionEvents() // user can interact again with the app
	}
}
