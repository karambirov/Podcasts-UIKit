//
//  PodcastsSearchViewModel.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 22/02/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import UIKit

final class PodcastsSearchViewModel {

    // MARK: - Private
    fileprivate var timer: Timer?
    fileprivate let networkingService = NetworkingService()

    // MARK: - Properties
    var podcasts = [Podcast]()
    var dataSource: TableViewDataSource<Podcast, PodcastCell>?

}

// MARK: - Methods
extension PodcastsSearchViewModel {

    func searchPodcasts(with query: String, completion: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { [weak self] timer in
            guard let self = self else { return }
            self.networkingService.fetchPodcasts(searchText: query) { [weak self] podcasts in
                guard let self = self else { return }
                self.podcastsDidLoad(podcasts)
                DispatchQueue.main.async {
                    completion()
                }
            }
        })
    }

    func deleteLoadedPodcasts() {
        podcasts.removeAll()
        dataSource = .make(for: podcasts)
    }

    func podcast(for indexPath: IndexPath) -> Podcast {
        return podcasts[indexPath.row]
    }

    fileprivate func podcastsDidLoad(_ podcasts: [Podcast]) {
        self.podcasts = podcasts
        dataSource = .make(for: podcasts)
    }

}
