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

    fileprivate func episodesDidLoad(_ episodes: [Episode]) {
        dataSource = .make(for: episodes)
    }

}
