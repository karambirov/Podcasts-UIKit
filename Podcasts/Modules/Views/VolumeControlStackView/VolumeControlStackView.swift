//
//  VolumeControlStackView.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 19/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import SnapKit
import UIKit

final class VolumeControlStackView: UIStackView {

    // MARK: - Properties
    private lazy var currentVolumeSlider = UISlider()
    private lazy var mutedVolumeImageView = UIImageView()
    private lazy var maxVolumeImageView = UIImageView()

    // MARK: - Life cycle
    override func didMoveToSuperview() {
        setupImageViews()
        setupLayout()
    }
}

// MARK: - Setup
extension VolumeControlStackView {

    private func setupLayout() {
        addArrangedSubview(mutedVolumeImageView)
        addArrangedSubview(currentVolumeSlider)
        addArrangedSubview(maxVolumeImageView)
    }

    private func setupImageViews() {
        mutedVolumeImageView.image = UIImage(systemSymbol: .speakerFill)
        maxVolumeImageView.image = UIImage(systemSymbol: .speaker3Fill)
    }
}
