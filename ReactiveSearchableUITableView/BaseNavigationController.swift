//
//  BaseNavigationController.swift
//  ReactiveSearchableUITableView
//
//  Created by Felipe Ferrari on 6/1/17.
//  Copyright © 2017 Felipe Ferrari. All rights reserved.
//


import UIKit

class BaseNavigationController: UINavigationController {
	override func viewDidLoad() {
		super.viewDidLoad()

		self.setupNavigationBar()
	}

	func setupNavigationBar() {
		self.navigationBar.isTranslucent = false

		self.navigationBar.tintColor = #colorLiteral(red: 0.4823529412, green: 0.4823529412, blue: 0.4823529412, alpha: 1)
		self.navigationBar.barTintColor = UIColor.white
		self.navigationBar.titleTextAttributes = [
			NSFontAttributeName : UIFont (name: "SanFranciscoDisplay-Medium", size: 16)!
		]
	}

	override func pushViewController( _ viewController: UIViewController, animated: Bool ) {
		setUpBackNavigationButton( viewController )

		super.pushViewController( viewController, animated: animated )
	}

	override func popViewController(animated: Bool) -> UIViewController? {
		let poppedVC = super.popViewController(animated: animated)

		if let poppedVC = poppedVC as? WireframeViewController {
			poppedVC.wireframe?.viewControllerWasPopped()
		}

		return poppedVC
	}

	func setUpBackNavigationButton( _ viewController: UIViewController ) {
		guard let navItem = self.topViewController?.navigationItem else { return }
		navItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
	}
}

