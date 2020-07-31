//
//  PlayerDetailsView.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 26/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import AVKit
import MediaPlayer
import UIKit

// FIXME: Fix spacing between title and author labels.
// TODO: Extract mini player in its own class
// TODO: Write MediaPlayerService and AVService

@available(*, deprecated, message: "It will be replaced with an equivalent view controller")
final class PlayerDetailsView: UIView {

    // MARK: - Properties
    // swiftlint:disable:next implicitly_unwrapped_optional
    var episode: Episode! {
        didSet {
            miniTitleLabel.text = episode.title
            titleLabel.text = episode.title
            authorLabel.text = episode.author

            playPauseButton.setImage(.pause, for: .normal)
            miniPlayPauseButton.setImage(.pause, for: .normal)

            setupNowPlayingInfo()
            setupAudioSession()
            playEpisode()

            guard let url = URL(string: episode.imageUrl?.httpsUrlString ?? "") else { return }
            episodeImageView.setImage(from: url)
            miniEpisodeImageView.setImage(from: url)

            miniEpisodeImageView.setImage(from: url) { image in
                let image = self.episodeImageView.image ?? UIImage()
                let artworkItem = MPMediaItemArtwork(boundsSize: .zero, requestHandler: { _ in image })
                MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = artworkItem
            }
        }
    }

    var playlistEpisodes = [Episode]()
    // swiftlint:disable:next implicitly_unwrapped_optional
    var panGesture: UIPanGestureRecognizer!

    // MARK: private
    private let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()

    private let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)

    // MARK: - Outlets
    @IBOutlet var maximizedStackView: UIStackView!

    @IBOutlet private var currentTimeSlider: UISlider!
    @IBOutlet private var currentTimeLabel: UILabel!
    @IBOutlet private var durationLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!

    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }

    @IBOutlet var playPauseButton: UIButton! {
        didSet {
            playPauseButton.setImage(.pause, for: .normal)
            playPauseButton.addTarget(self, action: #selector(playPause), for: .touchUpInside)
        }
    }

    @IBOutlet private var volumeSlider: UISlider! {
        didSet {
            volumeSlider.value = AVAudioSession.sharedInstance().outputVolume
        }
    }

    @IBOutlet private var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.layer.cornerRadius = 5
            episodeImageView.clipsToBounds = true
            episodeImageView.transform = shrunkenTransform
        }
    }

    // MARK: - Mini player outlets

    @IBOutlet var miniPlayerView: UIView!

    @IBOutlet private var miniEpisodeImageView: UIImageView!
    @IBOutlet private var miniTitleLabel: UILabel!

    @IBOutlet private var miniPlayPauseButton: UIButton! {
        didSet {
            miniPlayPauseButton.addTarget(self, action: #selector(playPause), for: .touchUpInside)
            miniPlayPauseButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }
    }

    @IBOutlet private var miniFastForwardButton: UIButton! {
        didSet {
            miniFastForwardButton.addTarget(self, action: #selector(fastForward(_:)), for: .touchUpInside)
            miniFastForwardButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        setupGestures()
        setupRemoteControl()
        setupInterruptionObserver()

        observePlayerCurrentTime()
        observeBoundaryTime()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
    }
}

// MARK: - Actions

extension PlayerDetailsView {
    static func initFromNib() -> PlayerDetailsView {
        // swiftlint:disable:next force_cast
        Bundle.main.loadNibNamed("PlayerDetailsView", owner: self, options: nil)?.first as! PlayerDetailsView
    }

    @IBAction
    private func handleCurrentTimeSliderChange(_: Any) {
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)

        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
        player.seek(to: seekTime)
    }

    @IBAction
    private func dismiss(_: Any) {
        let mainTabBarController = UIApplication.mainTabBarController
//        mainTabBarController?.minimizePlayerDetails()
    }

    @objc
    private func playPause() {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(.pause, for: .normal)
            miniPlayPauseButton.setImage(.pause, for: .normal)
            enlargeEpisodeImageView()
            setupElapsedTime(playbackRate: 1)
        } else {
            player.pause()
            playPauseButton.setImage(.play, for: .normal)
            miniPlayPauseButton.setImage(.play, for: .normal)
            shrinkEpisodeImageView()
            setupElapsedTime(playbackRate: 0)
        }
    }

    @IBAction
    private func rewind(_: Any) {
        seekToCurrentTime(delta: -15)
    }

    @IBAction
    private func fastForward(_: Any) {
        seekToCurrentTime(delta: 15)
    }

    @IBAction
    private func changeVolume(_ sender: UISlider) {
        player.volume = sender.value
        // TODO: Set value when volume change by pressing hardware buttons
    }
}

extension PlayerDetailsView {
    private func seekToCurrentTime(delta: Int64) {
        let seconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), seconds)
        player.seek(to: seekTime)
    }

    private func setupElapsedTime(playbackRate: Float) {
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate
    }

    private func setupNowPlayingInfo() {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = episode.author
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let sessionError {
            print("Failed to activate session:", sessionError)
        }
    }

    private func playEpisode() {
        if episode.fileUrl != nil {
            playEpisodeUsingFileUrl()
        } else {
            print("Trying to play episode at url:", episode.streamUrl.httpsUrlString)
            guard let url = URL(string: episode.streamUrl.httpsUrlString) else { return }
            let playerItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: playerItem)
            player.play()
        }
    }

    private func playEpisodeUsingFileUrl() {
        print("Attempt to play episode with file url:", episode.fileUrl ?? "")

        guard let fileUrl = URL(string: episode.fileUrl ?? "") else { return }
        let fileName = fileUrl.lastPathComponent

        guard var trueLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        trueLocation.appendPathComponent(fileName)
        print("True Location of episode:", trueLocation.absoluteString)
        let playerItem = AVPlayerItem(url: trueLocation)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }

    private func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTimeLabel.text = time.toDisplayString()
            let durationTime = self?.player.currentItem?.duration
            self?.durationLabel.text = durationTime?.toDisplayString()

            self?.updateCurrentTimeSlider()
        }
    }

    private func observeBoundaryTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]

        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            print("Episode started playing")
            self?.enlargeEpisodeImageView()
            self?.setupLockscreenDuration()
        }
    }

    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds

        currentTimeSlider.value = Float(percentage)
    }

    private func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = .identity
        })
    }

    private func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = self.shrunkenTransform
        })
    }
}

// MARK: - Gestures

extension PlayerDetailsView {
    // MARK: - Internal

    @objc
    func handlePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            handlePanChanged(gesture: gesture)
        } else if gesture.state == .ended {
            handlePanEnded(gesture: gesture)
        }
    }

    @objc
    func handleMaximize() {
//        UIApplication.mainTabBarController?.maximizePlayerDetails(for: nil)
    }

    // MARK: - private

    private func setupGestures() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMaximize)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        miniPlayerView.addGestureRecognizer(panGesture)

        maximizedStackView.addGestureRecognizer(UIPanGestureRecognizer(
            target: self,
            action: #selector(handleDismissalPan(gesture:))
        ))
    }

    private func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: superview)
        transform = CGAffineTransform(translationX: 0, y: translation.y)
        miniPlayerView.alpha = 1 + translation.y / 200
        maximizedStackView.alpha = -translation.y / 200
    }

    private func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: superview)
        let velocity = gesture.velocity(in: superview)
        print("Ended:", velocity.y)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            if translation.y < -200 || velocity.y < -500 {
                self.handleMaximize()
            } else {
                self.miniPlayerView.alpha = 1
                self.maximizedStackView.alpha = 0
            }
        })
    }

    @objc
    private func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            let translation = gesture.translation(in: superview)
            maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        } else if gesture.state == .ended {
            let translation = gesture.translation(in: superview)

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.maximizedStackView.transform = .identity

                if translation.y > 50 {
//                    UIApplication.mainTabBarController?.minimizePlayerDetails()
                }
            })
        }
    }
}

// MARK: - Background playing and Remote control

extension PlayerDetailsView {
    private func setupRemoteControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()

        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            self.player.play()
            self.playPauseButton.setImage(.pause, for: .normal)
            self.miniPlayPauseButton.setImage(.pause, for: .normal)

            self.setupElapsedTime(playbackRate: 1)
            return .success
        }

        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            self.playPauseButton.setImage(.play, for: .normal)
            self.miniPlayPauseButton.setImage(.play, for: .normal)

            self.setupElapsedTime(playbackRate: 0)
            return .success
        }

        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            self.playPause()
            return .success
        }

        commandCenter.nextTrackCommand.addTarget(self, action: #selector(handleNextTrack))
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(handlePrevTrack))
    }

    @objc
    private func handleNextTrack() {
        if playlistEpisodes.isEmpty { return }

        let currentEpisodeIndex = playlistEpisodes.firstIndex { episode -> Bool in
            self.episode.title == episode.title && self.episode.author == episode.author
        }

        guard let index = currentEpisodeIndex else { return }

        let nextEpisode: Episode
        if index == playlistEpisodes.count - 1 {
            nextEpisode = playlistEpisodes[0]
        } else {
            nextEpisode = playlistEpisodes[index + 1]
        }

        episode = nextEpisode
    }

    @objc
    private func handlePrevTrack() {
        if playlistEpisodes.isEmpty { return }

        let currentEpisodeIndex = playlistEpisodes.firstIndex { episode -> Bool in
            self.episode.title == episode.title && self.episode.author == episode.author
        }

        guard let index = currentEpisodeIndex else { return }

        let prevEpisode: Episode
        if index == 0 {
            let count = playlistEpisodes.count
            prevEpisode = playlistEpisodes[count - 1]
        } else {
            prevEpisode = playlistEpisodes[index - 1]
        }

        episode = prevEpisode
    }

    private func setupInterruptionObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
    }

    @objc
    private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let type = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else { return }

        if type == AVAudioSession.InterruptionType.began.rawValue {
            print("Interruption began")
            playPauseButton.setImage(.play, for: .normal)
            miniPlayPauseButton.setImage(.play, for: .normal)
        } else {
            print("Interruption ended")
            guard let options = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            if options == AVAudioSession.InterruptionOptions.shouldResume.rawValue {
                player.play()
                playPauseButton.setImage(.pause, for: .normal)
                miniPlayPauseButton.setImage(.pause, for: .normal)
            }
        }
    }

    private func setupLockscreenDuration() {
        guard let duration = player.currentItem?.duration else { return }
        let durationSeconds = CMTimeGetSeconds(duration)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationSeconds
    }
}
