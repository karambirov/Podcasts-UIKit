//
//  VolumeControlStackView.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 19/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import UIKit
import SnapKit

final class VolumeControlStackView: UIStackView {

    // MARK: - Properties
    fileprivate lazy var currentVolumeSlider  = UISlider()
    fileprivate lazy var mutedVolumeImageView = UIImageView()
    fileprivate lazy var maxVolumeImageView   = UIImageView()

    // MARK: - Life cycle
    override func didMoveToSuperview() {
        setupImageViews()
        setupLayout()
    }

}

// MARK: - Setup
extension VolumeControlStackView {

    fileprivate func setupLayout() {
        self.addArrangedSubview(mutedVolumeImageView)
        self.addArrangedSubview(currentVolumeSlider)
        self.addArrangedSubview(maxVolumeImageView)
    }

    fileprivate func setupImageViews() {
        mutedVolumeImageView.image = R.image.mutedVolume()
        maxVolumeImageView.image   = R.image.maxVolume()
    }

}
