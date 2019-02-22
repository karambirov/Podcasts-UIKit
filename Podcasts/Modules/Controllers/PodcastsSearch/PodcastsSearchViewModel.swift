//
//  PodcastsSearchViewModel.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 22/02/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import UIKit

struct PodcastsSearchViewModel {

    // MARK: - Properties
    var podcasts = [Podcast]()
    var dataSource: TableViewDataSource<Podcast, PodcastCell>?

}
