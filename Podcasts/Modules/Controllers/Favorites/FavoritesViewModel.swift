//
//  FavoritesViewModel.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 22/02/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Foundation

final class FavoritesViewModel {

    // MARK: - Private
    fileprivate let podcastsService = PodcastsService()

    // MARK: - Properties
    lazy var podcasts = podcastsService.savedPodcasts
    var dataSource: CollectionViewDataSource<Podcast, FavoritePodcastCell>?

}

// MARK: - Methods
extension FavoritesViewModel {

    func fetchFavorites(_ completion: @escaping () -> Void) {
        podcastsDidLoad(podcasts)
        DispatchQueue.main.async {
            completion()
        }
    }

    func podcast(for indexPath: IndexPath) -> Podcast {
        return podcasts[indexPath.item]
    }

    func deletePodcast(for indexPath: IndexPath) {
        podcasts.remove(at: indexPath.item)
        let selectedPodcast = podcast(for: indexPath)
        podcastsService.deletePodcast(selectedPodcast)
        dataSource = .make(for: podcasts)
    }

    fileprivate func podcastsDidLoad(_ podcasts: [Podcast]) {
        dataSource = .make(for: podcasts)
    }

}
