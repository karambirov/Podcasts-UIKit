//
//  PlayingControlsStackView.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 18/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import SFSafeSymbols
import UIKit

final class PlayingControlsStackView: UIStackView {

    // MARK: - Properties
    private lazy var rewindButton = UIButton(type: .system)
    private lazy var playPauseButton = UIButton(type: .system)
    private lazy var fastForwardButton = UIButton(type: .system)

    // MARK: - Life cycle
    override func didMoveToSuperview() {
        setupButtons()
        setupLayout()
    }
}

// MARK: - Setup
extension PlayingControlsStackView {

    private func setupLayout() {
        addArrangedSubview(rewindButton)
        addArrangedSubview(playPauseButton)
        addArrangedSubview(fastForwardButton)
        alignment = .center
        distribution = .fillEqually
    }

    private func setupButtons() {
        rewindButton.setImage(.gobackward15, for: .normal)
        playPauseButton.setImage(.pause, for: .normal)
        fastForwardButton.setImage(.goforward15, for: .normal)
    }
}
