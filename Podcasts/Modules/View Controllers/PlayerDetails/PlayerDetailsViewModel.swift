//
//  PlayerDetailsViewModel.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 07/04/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Foundation

final class PlayerDetailsViewModel {

    var episode: Episode
    let playerService = PlayerService()

    init(episode: Episode) {
        self.episode = episode
    }

    func playEpisode() {
        playerService.load(episode: episode)
    }

}
