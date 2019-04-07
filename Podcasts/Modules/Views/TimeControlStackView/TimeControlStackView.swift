//
//  TimeControlStackView.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 18/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import UIKit
import SnapKit

final class TimeControlStackView: UIStackView {

    // MARK: - Properties
    fileprivate lazy var currentTimeSlider = UISlider()
    fileprivate lazy var currentTimeLabel  = UILabel()
    fileprivate lazy var durationLabel     = UILabel()
    fileprivate lazy var timeStackView     = UIStackView(arrangedSubviews: [currentTimeLabel, durationLabel])

    // TODO: - Configure init to set labels text and value for slider
    // MARK: - Life cycle
    override func didMoveToSuperview() {
        setupLabels()
        setupLayout()
    }

}

// MARK: - Setup
extension TimeControlStackView {

    fileprivate func setupLayout() {
        self.axis    = .vertical
        self.spacing = 4
        self.addArrangedSubview(currentTimeSlider)
        self.addArrangedSubview(timeStackView)
        currentTimeSlider.snp.makeConstraints { $0.height.equalTo(36) }
        timeStackView.snp.makeConstraints { $0 .height.equalTo(22) }
    }

    fileprivate func setupLabels() {
        currentTimeLabel.text      = "00:00:00"
        currentTimeLabel.font      = .systemFont(ofSize: 12)
        currentTimeLabel.textColor = .lightGray
        // FIXME: Find out if it's necessary
//        currentTimeLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)

        durationLabel.text      = "--:--:--"
        durationLabel.font      = .systemFont(ofSize: 12)
        durationLabel.textColor = .lightGray
    }

}
