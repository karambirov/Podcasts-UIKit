//
//  EpisodesController.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 25/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit

final class EpisodesController: UITableViewController {

    // MARK: - Properties
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }

    var episodes = [Episode]()
    fileprivate let reuseIdentifier = "EpisodeCell"

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

}

// MARK: - UITableView
extension EpisodesController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EpisodeCell
        cell.episode = episodes[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let downloadAction = UITableViewRowAction(style: .normal, title: "Download") { (_, _) in
            print("\n\t\tDownloading episode into UserDefaults")
            let episode = self.episodes[indexPath.row]
            UserDefaults.standard.downloadEpisode(episode)
            NetworkService.shared.downloadEpisode(episode)
        }
        return [downloadAction]
    }

    // MARK: Footer Setup
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 : 0
    }

    // MARK: Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        let mainTabBarController = UIApplication.mainTabBarController
        mainTabBarController?.maximizePlayerDetails(episode: episode, playlistEpisodes: episodes)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Setup
extension EpisodesController {

    fileprivate func initialSetup() {
        setupTableView()
        setupNavigationBarButtons()
    }

    private func setupTableView() {
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
    }

    private func setupNavigationBarButtons() {
        let savedPodcasts = UserDefaults.standard.savedPodcasts
        let hasFavorited = savedPodcasts
            .index(where: { $0.trackName == self.podcast?.trackName &&
                   $0.artistName == self.podcast?.artistName }) != nil

        if hasFavorited {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(saveFavorite))
        }
    }

    fileprivate func fetchEpisodes() {
        print("\n\t\tLooking for episodes at feed url:", podcast?.feedUrl ?? "")

        guard let feedURL = podcast?.feedUrl else { return }
        NetworkService.shared.fetchEpisodes(feedUrl: feedURL) { episodes in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @objc private func saveFavorite() {
        print("\n\t\tSaving info into UserDefaults")

        guard let podcast = self.podcast else { return }

        var listOfPodcasts = UserDefaults.standard.savedPodcasts
        listOfPodcasts.append(podcast)
        let data = try! NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts, requiringSecureCoding: false)

        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)

        showBadgeHighlight()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
    }

    private func showBadgeHighlight() {
        UIApplication.mainTabBarController?.viewControllers?[1].tabBarItem.badgeValue = "New"
    }

}
