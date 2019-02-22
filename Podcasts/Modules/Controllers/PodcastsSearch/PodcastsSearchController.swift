//
//  PodcastsSearchController.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 21/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit
import Alamofire

final class PodcastsSearchController: UITableViewController {

    // MARK: - Properties
    fileprivate var podcasts = [Podcast]()
    fileprivate var timer: Timer?
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate var dataSource: TableViewDataSource<Podcast, PodcastCell>?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

}

// MARK: - UITableView
extension PodcastsSearchController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }

    // MARK: Header Setup
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = Keys.enterSearchTermMessage
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
        let podcastsSearchingView = Bundle.main.loadNibNamed(Keys.podcastsSearchingView,
                                                             owner: self)?.first as? UIView
        return podcastsSearchingView
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return podcasts.isEmpty && searchController.searchBar.text?.isEmpty == false ? 200 : 0
    }

    // MARK: Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodesController = EpisodesController()
        episodesController.podcast = podcast(for: indexPath)
        navigationController?.pushViewController(episodesController, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension PodcastsSearchController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        deleteLoadedPodcasts()
        tableView.reloadData()

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { timer in
            NetworkService.shared.fetchPodcasts(searchText: searchText, completionHandler: { [weak self] podcasts in
                guard let self = self else { return }
                self.podcastsDidLoad(podcasts)
                self.tableView.reloadData()
            })
        })
    }

}

// MARK: - Setup
extension PodcastsSearchController {

    fileprivate func initialSetup() {
        view.backgroundColor = .white
        setupSearchBar()
        setupTableView()
    }

    private func setupSearchBar() {
        self.definesPresentationContext                   = true
        navigationItem.searchController                   = searchController
        navigationItem.hidesSearchBarWhenScrolling        = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate               = self
    }

    private func setupTableView() {
        tableView.dataSource = dataSource
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: PodcastCell.typeName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: PodcastCell.typeName)
    }

    fileprivate func podcastsDidLoad(_ podcasts: [Podcast]) {
        self.podcasts = podcasts
        dataSource = .make(for: podcasts)
        tableView.dataSource = dataSource
    }

    fileprivate func deleteLoadedPodcasts() {
        podcasts.removeAll()
        dataSource = .make(for: podcasts)
        tableView.dataSource = dataSource
    }

    fileprivate func podcast(for indexPath: IndexPath) -> Podcast {
        return podcasts[indexPath.row]
    }

}

private extension PodcastsSearchController {

    enum Keys {
        static let podcastsSearchingView = "PodcastsSearchingView"
        static let enterSearchTermMessage = "Please, enter a search term."
    }

}
