//
//  EpisodeCellViewModel.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 12/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Foundation

final class EpisodeCellViewModel {

    // MARK: - Private
    fileprivate lazy var dateFormatter = DateFormatter()

    // MARK: - Properties
    var episode = Observable<Episode>()

    var episodeImageURL: URL {
        guard let url = URL(string: episode.value?.imageUrl?.httpsUrlString ?? "") else {
            preconditionFailure("Failed to load image URL.")
        }
        return url
    }

    var pubDate: String {
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: episode.value?.pubDate ?? Date())
    }

    // MARK: - Life cycle
    init(episode: Episode) {
        self.episode.value = episode
    }

}
