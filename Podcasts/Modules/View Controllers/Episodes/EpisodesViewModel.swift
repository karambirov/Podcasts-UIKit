//
//  EpisodesViewModel.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 22/02/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Foundation

final class EpisodesViewModel {

    let podcast: Podcast
    private let networkingService = NetworkingService()
    private let podcastsService: PodcastsService
    private let playerService: PlayerService
    private(set) var episodes = [Episode]()
    private(set) var dataSource: TableViewDataSource<Episode, EpisodeCell>?

    init(podcast: Podcast, podcastsService: PodcastsService, playerService: PlayerService) {
        self.podcast = podcast
        self.podcastsService = podcastsService
        self.playerService = playerService
    }
}

extension EpisodesViewModel {

    func fetchEpisodes(_ completion: @escaping () -> Void) {
        networkingService.fetchEpisodes(feedUrlSting: podcast.feedUrlSting) { [weak self] episodes in
            self?.episodesDidLoad(episodes)
            completion()
        }
    }

    func saveFavorite() {
        var listOfPodcasts = podcastsService.savedPodcasts
        listOfPodcasts.append(podcast)
        guard
            let data = try? NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts, requiringSecureCoding: false)
        else { return }
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
    }

    func download(_ episode: Episode) {
        print("Downloading episode into UserDefaults")
        podcastsService.downloadEpisode(episode)
        networkingService.downloadEpisode(episode)
    }

    func episode(for indexPath: IndexPath) -> Episode {
        episodes[indexPath.row]
    }

    func checkIfPodcastHasFavorited() -> Bool {
        let savedPodcasts = podcastsService.savedPodcasts.firstIndex {
            $0.trackName == self.podcast.trackName && $0.artistName == self.podcast.artistName
        }
        return savedPodcasts != nil
    }

    private func episodesDidLoad(_ episodes: [Episode]) {
        self.episodes = episodes
        dataSource = .make(for: episodes)
    }
}
