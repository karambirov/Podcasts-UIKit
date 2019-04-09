//
//  PlayerStackView.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 18/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import UIKit

final class PlayerStackView: UIStackView {

    // MARK: - Properties
    lazy var closeButton              = UIButton(type: .system)
    lazy var episodeImageView         = UIImageView()
    lazy var timeControlStackView     = TimeControlStackView()
    lazy var titleLabel               = UILabel()
    lazy var authorLabel              = UILabel()
    lazy var playingControlsStackView = PlayingControlsStackView()
    lazy var volumeControlStackView   = VolumeControlStackView()

    fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)

    // MARK: - Life cycle
    override func didMoveToSuperview() {
        setupEpisodeImageView()
        setupLabels()
        setupLayout()
    }

    func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = .identity
        })
    }

    func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = self.shrunkenTransform
        })
    }

}

// MARK: - Setup
extension PlayerStackView {

    fileprivate func setupLayout() {
        self.axis            = .vertical
        self.spacing         = 5
        let arrangedSubviews = [closeButton, episodeImageView, timeControlStackView, titleLabel, authorLabel, playingControlsStackView, volumeControlStackView]
        arrangedSubviews.forEach { self.addArrangedSubview($0) }
    }

    fileprivate func setupEpisodeImageView() {
        episodeImageView.image              = R.image.appicon()
        episodeImageView.layer.cornerRadius = 5
        episodeImageView.clipsToBounds      = true
        episodeImageView.snp.makeConstraints { $0.width.equalTo(episodeImageView.snp.height).multipliedBy(1/1) }
    }

    fileprivate func setupLabels() {
        titleLabel.textAlignment = .center
        titleLabel.font          = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.snp.makeConstraints { $0.height.greaterThanOrEqualTo(20) }

        authorLabel.textAlignment = .center
        authorLabel.font          = .systemFont(ofSize: 16, weight: .medium)
        authorLabel.textColor     = R.color.tintColor()
        authorLabel.snp.makeConstraints { $0.height.equalTo(20) }
    }

}
