//
//  PodcastsSearchController.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 21/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit
import Alamofire

// TODO: Replase strings with type-safety values

final class PodcastsSearchController: UITableViewController {

    // MARK: - Properties
    fileprivate var podcasts = [Podcast]()
    fileprivate var timer: Timer?
    fileprivate let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

}


// MARK: - UITableView
extension PodcastsSearchController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}


// MARK: - UISearchBarDelegate
extension PodcastsSearchController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        podcasts = []
        tableView.reloadData()

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { timer in
            // TODO: Fetch podcasts
            print("searching...")
        })
    }

}


// MARK: - Setup
extension PodcastsSearchController {

    fileprivate func initialSetup() {
        setupSearchBar()
        setupTableView()
    }

    fileprivate func setupSearchBar() {
        self.definesPresentationContext                   = true
        navigationItem.searchController                   = searchController
        navigationItem.hidesSearchBarWhenScrolling        = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate               = self
    }

    fileprivate func setupTableView() {
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PodcastCell")
        self.clearsSelectionOnViewWillAppear = false
    }
}
