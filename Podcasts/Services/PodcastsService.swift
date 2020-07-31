//
//  PodcastsService.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 14/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Foundation

final class PodcastsService {

    // MARK: - Properties
    var savedPodcasts: [Podcast] {
        fetchSavedPodcasts()
    }

    var downloadedEpisodes: [Episode] {
        fetchDownloadedEpisodes()
    }
}

// MARK: - Methods
extension PodcastsService {

    func deletePodcast(_ podcast: Podcast) {
        let podcasts = savedPodcasts
        let filteredPodcasts = podcasts.filter { podcast -> Bool in
            podcast.trackName != podcast.trackName && podcast.artistName != podcast.artistName
        }

        guard
            let data = try? NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts, requiringSecureCoding: false)
        else { return }
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
    }

    func downloadEpisode(_ episode: Episode) {
        do {
            var episodes = downloadedEpisodes
            episodes.insert(episode, at: 0)
            let data = try JSONEncoder().encode(episodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
        } catch let encodeError {
            print("Failed to encode episode:", encodeError)
        }
    }

    func deleteEpisode(_ episode: Episode) {
        let savedEpisodes = downloadedEpisodes
        let filteredEpisodes = savedEpisodes.filter { filteredEpisode -> Bool in
            filteredEpisode.title != episode.title
        }

        do {
            let data = try JSONEncoder().encode(filteredEpisodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
        } catch let encodeError {
            print("Failed to encode episode:", encodeError)
        }
    }
}

// MARK: - Private

extension PodcastsService {

    private func fetchSavedPodcasts() -> [Podcast] {
        guard
            let savedData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey),
            let savedPodcasts = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [Podcast.self], from: savedData) as? [Podcast]
        else { return [] }

        return savedPodcasts
    }

    private func fetchDownloadedEpisodes() -> [Episode] {
        guard
            let episodesData = UserDefaults.value(forKey: UserDefaults.downloadedEpisodesKey) as? Data
        else { return [] }

        do {
            return try JSONDecoder().decode([Episode].self, from: episodesData)
        } catch let decodeError {
            print("Failed to decode:", decodeError)
        }

        return []
    }
}
