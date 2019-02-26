//
//  FavoritesViewModel.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 22/02/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Foundation

final class FavoritesViewModel {

    // MARK: - Properties
    var podcasts = UserDefaults.standard.savedPodcasts
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
        UserDefaults.standard.deletePodcast(selectedPodcast)
        dataSource = .make(for: podcasts)
    }

    fileprivate func podcastsDidLoad(_ podcasts: [Podcast]) {
        dataSource = .make(for: podcasts)
    }

}
