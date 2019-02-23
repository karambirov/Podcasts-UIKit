//
//  DownloadsController.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 21/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit

final class DownloadsViewController: UITableViewController {

    // MARK: - Properties
    fileprivate let reuseIdentifier = "EpisodeCell"
    fileprivate var episodes = UserDefaults.standard.downloadedEpisodes

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodes = UserDefaults.standard.downloadedEpisodes
        tableView.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .downloadProgress, object: nil)
        NotificationCenter.default.removeObserver(self, name: .downloadComplete, object: nil)
    }

}

// MARK: - TableView
extension DownloadsViewController {

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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\n\t\tLaunch episode player")
        let episode = episodes[indexPath.row]

        if episode.fileUrl != nil {
            UIApplication.mainTabBarController?.maximizePlayerDetails(episode: episode, playlistEpisodes: episodes)
        } else {
            let alertController = UIAlertController(title: "File URL not found", message: "Cannot find local file, play using stream URL instead", preferredStyle: .actionSheet)

            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                UIApplication.mainTabBarController?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            present(alertController, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        episodes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        UserDefaults.standard.deleteEpisode(episode)
    }

}

// MARK: - Setup
extension DownloadsViewController {

    fileprivate func initialSetup() {
        setupTableView()
        setupObservers()
    }

    private func setupTableView() {
        tableView.tableFooterView = UIView()
        let nib = UINib(resource: R.nib.episodeCell)
        tableView.register(nib, forCellReuseIdentifier: EpisodeCell.typeName)
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadComplete, object: nil)
    }

    @objc private func handleDownloadProgress(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        guard let progress = userInfo["progress"] as? Double else { return }
        guard let title = userInfo["title"] as? String else { return }

        print("\n\t\t", progress, title)

        guard let index = episodes.firstIndex(where: { $0.title == title }) else { return }
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpisodeCell else { return }
        cell.progressLabel.text = "\(Int(progress * 100))%"
        cell.progressLabel.isHidden = false

        if progress == 1 {
            cell.progressLabel.isHidden = true
        }
    }

    @objc private func handleDownloadComplete(notification: Notification) {
        guard let  episodeDownloadComplete = notification.object as? NetworkService.EpisodeDownloadComplete else { return }
        guard let index = episodes.firstIndex(where: { $0.title == episodeDownloadComplete.episodeTitle }) else { return }
        episodes[index].fileUrl = episodeDownloadComplete.fileUrl
    }

}
