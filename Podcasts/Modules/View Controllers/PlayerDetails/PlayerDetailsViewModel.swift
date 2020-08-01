//
//  PlayerDetailsViewModel.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 07/04/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Foundation

final class PlayerDetailsViewModel {

    let episode: Episode
    private let playerService: PlayerService

    init(episode: Episode, playerService: PlayerService) {
        self.episode = episode
        self.playerService = playerService
    }

    var currentTime: Double {
        playerService.currentTime
    }

    func playEpisode() {
        playerService.load(episode: episode)
        playerService.play()
    }
}
