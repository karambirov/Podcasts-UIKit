//
//  PlayingControlsStackView.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 18/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import UIKit

final class PlayingControlsStackView: UIStackView {

    // MARK: - Properties
    lazy var rewindButton      = UIButton(type: .system)
    lazy var playPauseButton   = UIButton(type: .system)
    lazy var fastForwardButton = UIButton(type: .system)

    // MARK: - Life cycle
    override func didMoveToSuperview() {
        setupButtons()
        setupLayout()
    }

}

// MARK: - Setup
extension PlayingControlsStackView {

    fileprivate func setupLayout() {
        self.addArrangedSubview(rewindButton)
        self.addArrangedSubview(playPauseButton)
        self.addArrangedSubview(fastForwardButton)
        self.alignment    = .center
        self.distribution = .fillEqually

    }

    fileprivate func setupButtons() {
        rewindButton.setImage(R.image.rewind15(), for: .normal)
        playPauseButton.setImage(R.image.pause(), for: .normal)
        fastForwardButton.setImage(R.image.fastforward15(), for: .normal)
    }

}
