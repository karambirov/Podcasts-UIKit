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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PodcastCell", for: indexPath) as! PodcastCell
        cell.podcast = podcasts[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }

    // MARK: Header Setup
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please, enter a search term."
        label.textAlignment = .center
        label.textColor = .purple
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return podcasts.isEmpty && searchController.searchBar.text?.isEmpty == true ? (tableView.bounds.height / 2) : 0
    }

    // MARK: Footer Setup
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let podcastsSearchingView = Bundle.main.loadNibNamed("PodcastsSearchingView", owner: self)?.first as? UIView
        return podcastsSearchingView
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return podcasts.isEmpty && searchController.searchBar.text?.isEmpty == false ? 200 : 0
    }

    // MARK: Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodesController = EpisodesController()
        let podcast = podcasts[indexPath.row]
        episodesController.podcast = podcast
        navigationController?.pushViewController(episodesController, animated: true)
    }
}


// MARK: - UISearchBarDelegate
extension PodcastsSearchController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        podcasts = []
        tableView.reloadData()

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { timer in
            NetworkService.shared.fetchPodcasts(searchText: searchText, completionHandler: { podcasts in
                self.podcasts = podcasts
                self.tableView.reloadData()
            })
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
