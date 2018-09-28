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

    func deletePodcast(podcast: Podcast) {
        let podcasts = savedPodcasts
        let filteredPodcasts = podcasts.filter { p -> Bool in
            return p.trackName != podcast.trackName && p.artistName != podcast.artistName
        }

        let data = NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
    }
}
