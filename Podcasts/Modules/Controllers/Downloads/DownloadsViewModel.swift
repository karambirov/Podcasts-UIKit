//
//  DownloadsViewModel.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 26/02/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Foundation

final class DownloadsViewModel {

    // MARK: - Properties
    var episodes = UserDefaults.standard.downloadedEpisodes
    var dataSource: TableViewDataSource<Episode, EpisodeCell>?

}

// MARK: - Methods
extension DownloadsViewModel {

    func fetchDownloads(_ completion: @escaping () -> Void) {
        episodesDidLoad(episodes)
        DispatchQueue.main.async {
            completion()
        }
    }

    func episode(for indexPath: IndexPath) -> Episode {
        return episodes[indexPath.row]
    }

    func deleteEpisode(for indexPath: IndexPath) {
        episodes.remove(at: indexPath.row)
        let selectedEpisode = episode(for: indexPath)
        UserDefaults.standard.deleteEpisode(selectedEpisode)
        dataSource = .make(for: episodes)
    }

    @objc
    func handleDownloadComplete(notification: Notification) {
        guard let  episodeDownloadComplete = notification.object as? NetworkService.EpisodeDownloadComplete else { return }
        guard let index = episodes.firstIndex(where: { $0.title == episodeDownloadComplete.episodeTitle }) else { return }
        episodes[index].fileUrl = episodeDownloadComplete.fileUrl
    }

    fileprivate func episodesDidLoad(_ episodes: [Episode]) {
        dataSource = .make(for: episodes)
    }

}
