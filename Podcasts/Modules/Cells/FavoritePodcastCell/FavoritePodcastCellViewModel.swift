//
//  FavoritePodcastCellViewModel.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 12/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Foundation

final class FavoritePodcastCellViewModel {

    // MARK: - Properties
    var podcast = Observable<Podcast>()

    var podcastImageURL: URL {
        guard let url = URL(string: podcast.value?.artworkUrl600?.httpsUrlString ?? "") else {
            preconditionFailure("Failed to load image URL.")
        }
        return url
    }

    // MARK: - Life cycle
    init(podcast: Podcast) {
        self.podcast.value = podcast
    }

}
