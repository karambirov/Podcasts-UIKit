//
//  PlayerService.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 07/04/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import ModernAVPlayer

final class PlayerService {

    private var media: ModernAVPlayerMedia?
    private var player = ModernAVPlayer(loggerDomains: [.state, .error, .lifecycleService, .lifecycleState])

    func load(episode: Episode) {
        guard let episodeURL = URL(string: episode.fileUrl?.httpsUrlString ?? "") else { return }
        let metadata = ModernAVPlayerMediaMetadata(title: episode.title, artist: episode.author)
        media = ModernAVPlayerMedia(url: episodeURL, type: .stream(isLive: true), metadata: metadata)
        guard let media = media else { return }
        player.load(media: media, autostart: true)
    }

    // MARK: - Playing commands
    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    func rewind() {
        player.seek(position: -15)
    }

    func fastForward() {
        player.seek(position: 15)
    }

//    func changeVolume(value: Double) {
//
//    }

}
