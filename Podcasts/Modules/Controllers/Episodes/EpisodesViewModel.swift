//
//  EpisodesViewModel.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 22/02/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Foundation

final class EpisodesViewModel {

    // MARK: - Properties
    let podcast: Podcast
    var episodes = [Episode]()
    var dataSource: TableViewDataSource<Episode, EpisodeCell>?

    init(podcast: Podcast) {
        self.podcast = podcast
    }

    func fetchEpisodes(_ completion: @escaping () -> Void) {
        print("\n\t\tLooking for episodes at feed url:", podcast.feedUrl ?? "")

        guard let feedURL = podcast.feedUrl else { return }
        NetworkService.shared.fetchEpisodes(feedUrl: feedURL) { episodes in
            self.episodes = episodes
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    private func episodesDidLoad(_ episodes: [Episode]) {
        self.episodes = episodes
        dataSource = .make(for: episodes)
    }

    func deleteLoadedEpisodes() {
        episodes.removeAll()
        dataSource = .make(for: episodes)
    }

    func episode(for indexPath: IndexPath) -> Episode {
        return episodes[indexPath.row]
    }
}
