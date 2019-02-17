//
//  UserDefaults+Extensions.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 26/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import Foundation

extension UserDefaults {

    static let favoritedPodcastKey = "favoritedPodcastKey"
    static let downloadedEpisodesKey = "downloadEpisodesKey"

    var savedPodcasts: [Podcast] {
        guard let savedPodcastsData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else { return [] }
        guard let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: savedPodcastsData) as? [Podcast] else { return [] }
        return savedPodcasts
    }

    var downloadedEpisodes: [Episode] {
        guard let episodesData = data(forKey: UserDefaults.downloadedEpisodesKey) else { return [] }

        do {
            return try JSONDecoder().decode([Episode].self, from: episodesData)
        } catch let decodeError {
            print("\n\t\tFailed to decode:", decodeError)
        }

        return []
    }

    func deletePodcast(_ podcast: Podcast) {
        let podcasts = savedPodcasts
        let filteredPodcasts = podcasts.filter { p -> Bool in
            return p.trackName != podcast.trackName && p.artistName != podcast.artistName
        }

        let data = NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
    }

    func downloadEpisode(_ episode: Episode) {
        do {
            var episodes = downloadedEpisodes
            episodes.insert(episode, at: 0)
            let data = try JSONEncoder().encode(episodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
        } catch let encodeError {
            print("\n\t\tFailed to encode episode:", encodeError)
        }
    }

    func deleteEpisode(_ episode: Episode) {
        let savedEpisodes = downloadedEpisodes
        let filteredEpisodes = savedEpisodes.filter { e -> Bool in
            return e.title != episode.title
        }

        do {
            let data = try JSONEncoder().encode(filteredEpisodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
        } catch let encodeError {
            print("\n\t\tFailed to encode episode:", encodeError)
        }
    }
}
