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
    var viewModel = PodcastsSearchViewModel()
    fileprivate let searchController = UISearchController(searchResultsController: nil)

    // MARK: - View Controller's life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesSearchBarWhenScrolling = false
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationItem.hidesSearchBarWhenScrolling = true
        super.viewDidAppear(animated)
    }

}

// MARK: - UITableView
extension PodcastsSearchController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Sizes.cellHeight
    }

    // MARK: Header Setup
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let emptyStateView = setupEmptyStateView()
        return emptyStateView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.podcasts.isEmpty && searchController.searchBar.text?.isEmpty == true ? (tableView.bounds.height / 2) : 0
    }

    // MARK: Footer Setup
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let podcastsSearchingView = Bundle.main.loadNibNamed(Keys.podcastsSearchingView,
                                                             owner: self)?.first as? UIView
        return podcastsSearchingView
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.podcasts.isEmpty && searchController.searchBar.text?.isEmpty == false ? 200 : 0
    }

    // MARK: Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodesController = EpisodesController()
        episodesController.podcast = viewModel.podcast(for: indexPath)
        navigationController?.pushViewController(episodesController, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension PodcastsSearchController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchPodcasts(with: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.deleteLoadedPodcasts()
        tableView.reloadData()
    }

}

// MARK: - Setup
extension PodcastsSearchController {

    fileprivate func initialSetup() {
        view.backgroundColor = .white
        setupSearchBar()
        setupTableView()
    }

    fileprivate func searchPodcasts(with searchText: String) {
        viewModel.deleteLoadedPodcasts()
        tableView.reloadData()

        guard searchText.count > 2 else { return }
        viewModel.searchPodcasts(with: searchText) { [weak self] in
            guard let self = self else { return }
            self.tableView.dataSource = self.viewModel.dataSource
            self.tableView.reloadData()
        }
    }

    fileprivate func setupEmptyStateView() -> UIView? {
        let label = UILabel()
        label.text = Keys.enterSearchTermMessage
        label.textAlignment = .center
        label.textColor = .purple
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }

    private func setupSearchBar() {
        self.definesPresentationContext                   = true
        navigationItem.searchController                   = searchController
        navigationItem.hidesSearchBarWhenScrolling        = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate               = self
    }

    private func setupTableView() {
        tableView.dataSource = viewModel.dataSource
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: PodcastCell.typeName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: PodcastCell.typeName)
    }

}

private extension PodcastsSearchController {

    enum Keys {
        static let podcastsSearchingView = "PodcastsSearchingView"
        static let enterSearchTermMessage = "Please, enter a search term."
    }

    enum Sizes {
        static let cellHeight: CGFloat = 132
    }

}
