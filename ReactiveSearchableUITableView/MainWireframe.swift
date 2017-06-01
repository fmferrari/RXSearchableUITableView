//
//  MainWireframe.swift
//  ReactiveSearchableUITableView
//
//  Created by Felipe Ferrari on 6/1/17.
//  Copyright © 2017 Felipe Ferrari. All rights reserved.
//

import UIKit

class MainWireframe: Wireframe {

	required init(navigation: Navigation) {

		super.init(navigation: navigation)
		self.viewController = RXSearchableTableViewController()
	}

}
