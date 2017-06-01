//
//  Wireframe.swift
//  ReactiveSearchableUITableView
//
//  Created by Felipe Ferrari on 6/1/17.
//  Copyright © 2017 Felipe Ferrari. All rights reserved.
//

import UIKit

enum WireframeViewControllerError: Error {
	case viewControllerWithoutWireframe
}

enum WireframePresentationError : Error {
	case nilSelfViewController
	case nilOverViewController
	case notNavigationController
}

protocol ViewControllerWithWireframe {
	weak var wireframe: Wireframe? { get set }
}

class WireframeViewController : UIViewController, ViewControllerWithWireframe {
	weak var wireframe: Wireframe?

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		wireframe?.viewControllerWillAppear()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		wireframe?.viewControllerDidDisappear()
	}
}

class Wireframe {
	var viewController : UIViewController? {
		didSet {
			if var wireframeVC = viewController as? ViewControllerWithWireframe {
				wireframeVC.wireframe = self
			}
		}
	}
	var navigationController : BaseNavigationController? {
		guard let selfVC = self.viewController else { return nil }

		if let navController = selfVC.navigationController as? BaseNavigationController {
			return navController
		} else {
			// FIXME: I'm not sure this is the best way to do it, if the nav controller doesn't
			// exists, don't create one. The user should explicitily create it if he wants the wireframe's
			// view controller to be presented in a navigation
			return BaseNavigationController( rootViewController: selfVC )
		}
	}

	var navigation: Navigation
	var presenting : Wireframe?
	weak var presentedBy : Wireframe?
	weak var parent: Wireframe?

	required init(navigation: Navigation) {
		self.navigation = navigation
	}

	func setAsRootWireframe( inNavigation: Bool = false ) throws {
		guard let selfVC = self.viewController else { throw WireframePresentationError.nilSelfViewController }

		let vcToPresent = inNavigation ? self.navigationController! : selfVC

		navigation.window.rootViewController = vcToPresent
		navigation.rootWireframe = self
	}

	// Modal
	func present( over: Wireframe, animated: Bool = true, completion: (() -> Void)? = nil ) throws {
		guard let selfVC = self.viewController else { throw WireframePresentationError.nilSelfViewController }
		guard let overVC = over.viewController else { throw WireframePresentationError.nilOverViewController }

		overVC.present( selfVC, animated: animated, completion: completion )

		over.presenting  = self
		self.presentedBy = over
	}

	func presentInNavigation( over: Wireframe, animated: Bool = true, completion: (() -> Void)? = nil ) throws {
		guard let selfVC = self.viewController else { throw WireframePresentationError.nilSelfViewController }
		guard let overVC = over.viewController else { throw WireframePresentationError.nilOverViewController }

		let selfNVC = BaseNavigationController( rootViewController: selfVC )
		overVC.present( selfNVC, animated: animated, completion: completion )

		over.presenting  = self
		self.presentedBy = over
	}

	func dismiss (animated: Bool = true, completion: (() -> Void)? = nil ) throws {
		guard let selfVC = self.viewController else { throw WireframePresentationError.nilSelfViewController }

		selfVC.dismiss(animated: animated, completion: completion)

		self.presentedBy?.presenting = nil
	}


	// Push Navigation
	func push( inWireframe: Wireframe, animated: Bool = true ) throws {
		guard let inVC   = inWireframe.viewController?.navigationController else { throw WireframePresentationError.notNavigationController }
		guard let selfVC = self.viewController else { throw WireframePresentationError.nilSelfViewController }

		inVC.pushViewController( selfVC, animated: animated )

		inWireframe.presenting  = self
		self.presentedBy = inWireframe
	}

	@discardableResult
	func pop( animated: Bool ) throws -> UIViewController? {
		guard let selfNavigationVC = self.viewController?.navigationController else { throw WireframePresentationError.notNavigationController }

		return selfNavigationVC.popViewController( animated: animated )
	}

	@discardableResult
	func popToRoot (animated: Bool = true) throws -> [UIViewController]? {
		guard let selfNavigationVC = self.viewController?.navigationController else {
			throw WireframePresentationError.notNavigationController
		}

		return selfNavigationVC.popToRootViewController(animated: animated)
	}

	private var isPoppingViewController: Bool = false

	func viewControllerWillAppear () {

	}

	func viewControllerDidDisappear () {
		if isPoppingViewController {
			self.presentedBy?.presenting = nil
			isPoppingViewController = false
		}
	}

	func viewControllerWasPopped () {
		isPoppingViewController = true
	}
}

