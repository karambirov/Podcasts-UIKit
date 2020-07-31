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
    private lazy var closeButton = UIButton(type: .system)
    private lazy var episodeImageView = UIImageView()
    private lazy var timeControlStackView = TimeControlStackView()
    private lazy var titleLabel = UILabel()
    private lazy var authorLabel = UILabel()
    private lazy var playingControlsStackView = PlayingControlsStackView()
    private lazy var volumeControlStackView = VolumeControlStackView()

    // MARK: - Life cycle
    override func didMoveToSuperview() {
        setupEpisodeImageView()
        setupLabels()
        setupLayout()
    }
}

// MARK: - Setup
extension PlayerStackView {

    private func setupLayout() {
        axis = .vertical
        spacing = 5
        let arrangedSubviews = [closeButton, episodeImageView, timeControlStackView, titleLabel, authorLabel, playingControlsStackView, volumeControlStackView]
        arrangedSubviews.forEach { self.addArrangedSubview($0) }
    }

    private func setupEpisodeImageView() {
        episodeImageView.image = UIImage()
        episodeImageView.layer.cornerRadius = 5
        episodeImageView.clipsToBounds = true
        episodeImageView.snp.makeConstraints { $0.width.equalTo(episodeImageView.snp.height).multipliedBy(1 / 1) }
    }

    private func setupLabels() {
        titleLabel.text = "Episode Title"
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.snp.makeConstraints { $0.height.greaterThanOrEqualTo(20) }

        authorLabel.text = "Author"
        authorLabel.textAlignment = .center
        authorLabel.font = .systemFont(ofSize: 16, weight: .medium)
        authorLabel.textColor = AppConfig.tintColor
        authorLabel.snp.makeConstraints { $0.height.equalTo(20) }
    }
}
