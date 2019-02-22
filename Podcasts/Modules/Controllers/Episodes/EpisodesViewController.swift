//
//  EpisodesController.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 25/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit

final class EpisodesViewController: UITableViewController {

    // MARK: - Properties
    fileprivate let viewModel: EpisodesViewModel

    // MARK: - View Controller's life cycle
    init(viewModel: EpisodesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

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
        return Sizes.cellHeight
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let downloadAction = UITableViewRowAction(style: .normal,
                                                  title: Strings.downloadRowActionTitle) { (_, _) in
            print("\n\t\tDownloading episode into UserDefaults")
            let episode = self.viewModel.episode(for: indexPath)
            UserDefaults.standard.downloadEpisode(episode)
            NetworkService.shared.downloadEpisode(episode)
        }
        return [downloadAction]
    }

    // MARK: Footer Setup
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return setupLoadingView()
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.episodes.isEmpty ? Sizes.footerHeight : 0
    }

    // MARK: Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = viewModel.episode(for: indexPath)
        let mainTabBarController = UIApplication.mainTabBarController
        mainTabBarController?.maximizePlayerDetails(episode: episode,
                                                    playlistEpisodes: viewModel.episodes)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Setup
extension EpisodesViewController {

    fileprivate func initialSetup() {
        setupTableView()
        setupNavigationBarButtons()
    }

    fileprivate func setupLoadingView() -> UIView {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }

    private func setupTableView() {
        let nib = UINib(nibName: EpisodeCell.typeName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: EpisodeCell.typeName)
        tableView.dataSource = viewModel.dataSource
        tableView.tableFooterView = UIView()
    }

    private func setupNavigationBarButtons() {
        let savedPodcasts = UserDefaults.standard.savedPodcasts
        let hasFavorited = savedPodcasts
            .index(where: { $0.trackName  == self.viewModel.podcast.trackName &&
                            $0.artistName == self.viewModel.podcast.artistName }) != nil

        if hasFavorited {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain,
                                                                target: nil, action: nil)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: Strings.favoriteNavBarButtonTitle,
                                                                style: .plain, target: self,
                                                                action: #selector(saveFavorite))
        }
    }

    @objc private func saveFavorite() {
        print("\n\t\tSaving info into UserDefaults")

        var listOfPodcasts = UserDefaults.standard.savedPodcasts
        listOfPodcasts.append(viewModel.podcast)
        let data = try! NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts,
                                                     requiringSecureCoding: false)

        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)

        showBadgeHighlight()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain,
                                                            target: nil, action: nil)
    }

    private func showBadgeHighlight() {
        UIApplication.mainTabBarController?.viewControllers?[1].tabBarItem.badgeValue = "New"
    }

}

private extension EpisodesViewController {

    enum Strings {
        static let favoriteNavBarButtonTitle = "Favorite"
        static let downloadRowActionTitle    = "Download"
    }

    enum Sizes {
        static let cellHeight: CGFloat = 134
        static let footerHeight: CGFloat = 200
    }

}
