//
//  PodcastCellViewModel.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 12/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Foundation

final class PodcastCellViewModel {

    var podcast = Observable<Podcast>()

    var podcastImageURL: URL {
        guard let url = URL(string: podcast.value?.artworkUrl600 ?? "") else {
            preconditionFailure("Failed to load image URL.")
        }
        return url
    }

    init(podcast: Podcast) {
        self.podcast.value = podcast
    }


}
