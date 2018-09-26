//
//  PlayerDetailsView.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 26/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit

class PlayerDetailsView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var maximizedStackView: UIStackView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    @IBOutlet weak var episodeImageView: UIImageView!


    // MARK: - Actions
    @IBAction func handleCurrentTimeSliderChange(_ sender: Any) {
    }

    @IBAction func dismiss(_ sender: Any) {
    }
    @IBAction func rewind(_ sender: Any) {
    }
    @IBAction func playPause(_ sender: Any) {
    }
    @IBAction func fastForward(_ sender: Any) {
    }
    @IBAction func changeVolume(_ sender: UISlider) {
    }

}
