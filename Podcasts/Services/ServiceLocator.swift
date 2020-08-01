//
//  ServiceLocator.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 01.08.2020.
//  Copyright © 2020 Eugene Karambirov. All rights reserved.
//

import Foundation

enum ServiceLocator {

    static let networkingService = NetworkingService()
    static let podcastsService = PodcastsService()
    static let playerService = PlayerService()
}
