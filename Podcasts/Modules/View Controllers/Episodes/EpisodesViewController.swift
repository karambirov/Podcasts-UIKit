//
//  EpisodesController.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 25/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import SPStorkController
import UIKit

final class EpisodesViewController: UITableViewController {

    // MARK: - Properties
    private let viewModel: EpisodesViewModel

    // MARK: - View Controller's life cycle
    init(viewModel: EpisodesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

	@available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()

        viewModel.fetchEpisodes { [weak self] in
            guard let self = self else { return }
            self.navigationItem.title = self.viewModel.podcast.trackName
            self.tableView.dataSource = self.viewModel.dataSource
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableView
extension EpisodesViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Sizes.cellHeight
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let downloadAction = UITableViewRowAction(
            style: .normal,
            title: Strings.downloadRowActionTitle
        ) { [weak self] _, _ in
            guard let self = self else { return }
            let episode = self.viewModel.episode(for: indexPath)
            self.viewModel.download(episode)
        }
        return [downloadAction]
    }

    // MARK: Footer Setup
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        setupLoadingView()
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        viewModel.episodes.isEmpty ? Sizes.footerHeight : 0
    }

    // MARK: Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = viewModel.episode(for: indexPath)
//        let mainTabBarController = UIApplication.mainTabBarController
//        mainTabBarController?.maximizePlayerDetails(for: episode,
//                                                    playlistEpisodes: viewModel.episodes)
        let playerVM = PlayerDetailsViewModel()
        let playerVC = PlayerDetailsViewController(viewModel: playerVM)
        presentAsStork(playerVC)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Setup
extension EpisodesViewController {

    private func initialSetup() {
        setupTableView()
        setupNavigationBarButtons()
    }

    private func setupLoadingView() -> UIView {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }

    private func setupTableView() {
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.typeName)
        tableView.dataSource = viewModel.dataSource
        tableView.tableFooterView = UIView()
    }

    // TODO: There's no way to unfavorite. Add deleteFavorite() and refactor below logic
    private func setupNavigationBarButtons() {
        let hasFavorited = viewModel.checkIfPodcastHasFavorited()

        if hasFavorited {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemSymbol: .heartFill),
                style: .plain,
                target: nil,
                action: nil
            )
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemSymbol: .heart),
                style: .plain,
                target: self,
                action: #selector(saveFavorite)
            )
        }
    }

    @objc
    private func saveFavorite() {
        viewModel.saveFavorite()
        showBadgeHighlight()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemSymbol: .heart),
            style: .plain,
            target: nil,
            action: nil
        )
    }

    private func showBadgeHighlight() {
        UIApplication.mainTabBarController?.viewControllers?[1].tabBarItem.badgeValue = Strings.tabBarBadgeTitle
    }
}

private extension EpisodesViewController {

    enum Strings {
        static let favoriteNavBarButtonTitle = "Favorite"
        static let downloadRowActionTitle = "Download"
        static let tabBarBadgeTitle = "New"
    }

    enum Sizes {
        static let cellHeight: CGFloat = 134
        static let footerHeight: CGFloat = 200
    }
}
