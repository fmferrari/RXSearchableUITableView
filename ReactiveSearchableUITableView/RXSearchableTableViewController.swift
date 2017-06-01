//
//  RXSearchableTableViewController.swift
//  ReactiveSearchableUITableView
//
//  Created by Felipe Ferrari on 6/1/17.
//  Copyright © 2017 Felipe Ferrari. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RXSearchableTableViewController: UIViewController, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	let disposeBag = DisposeBag()

	var shownCities = [String]() // Data source for UITableView
	let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"]

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.dataSource = self
		self.tableView.register(PrototypeTableViewCell.self, forCellReuseIdentifier: "PrototypeTableViewCell")
		setUpSearchBar()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func setUpSearchBar() {
		searchBar
			.rx.text // Observable property thanks to RxCocoa
			.orEmpty // Make it non-optional
			.debounce(0.5, scheduler: MainScheduler.instance) // Wait 0.5 for changes.
			.distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
			.filter { !$0.isEmpty } // If the new value is really new, filter for non-empty query.
			.subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value, that is not empty (thanks to filter above).
				self.shownCities = self.allCities.filter { $0.hasPrefix(query) } // We now do our "API Request" to find cities.
				self.tableView.reloadData() // And reload table view data.
			})
			.addDisposableTo(disposeBag)
	}

	// MARK: - UITableViewDataSource

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return shownCities.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "PrototypeTableViewCell", for: indexPath) as! PrototypeTableViewCell
		cell.textLabel?.text = shownCities[indexPath.row]

		return cell
	}


}
