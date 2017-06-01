//
//  Navigation.swift
//  ReactiveSearchableUITableView
//
//  Created by Felipe Ferrari on 6/1/17.
//  Copyright © 2017 Felipe Ferrari. All rights reserved.
//

import UIKit

class Navigation {
	var window: UIWindow
	var rootWireframe: Wireframe?

	init (window: UIWindow) {
		self.window = window
		self.rootWireframe = nil
	}
}
