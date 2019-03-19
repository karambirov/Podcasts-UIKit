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
    fileprivate lazy var closeButton              = UIButton(type: .system)
    fileprivate lazy var episodeImageView         = UIImageView()
    fileprivate lazy var timeControlStackView     = TimeControlStackView()
    fileprivate lazy var titleLabel               = UILabel()
    fileprivate lazy var authorLabel              = UILabel()
    fileprivate lazy var playingControlsStackView = PlayingControlsStackView()
    fileprivate lazy var volumeControlStackView   = VolumeControlStackView()

}
