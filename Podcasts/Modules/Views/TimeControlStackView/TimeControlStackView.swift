//
//  TimeControlStackView.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 18/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import SnapKit
import UIKit

final class TimeControlStackView: UIStackView {

    // MARK: - Properties
    private lazy var currentTimeSlider = UISlider()
    private lazy var currentTimeLabel = UILabel()
    private lazy var durationLabel = UILabel()
    private lazy var timeStackView = UIStackView(arrangedSubviews: [currentTimeLabel, durationLabel])

    // TODO: - Configure init to set labels text and value for slider

    // MARK: - Life cycle
    override func didMoveToSuperview() {
        setupLabels()
        setupLayout()
    }
}

// MARK: - Setup
extension TimeControlStackView {

    private func setupLayout() {
        axis = .vertical
        spacing = 4
        addArrangedSubview(currentTimeSlider)
        addArrangedSubview(timeStackView)
        currentTimeSlider.snp.makeConstraints { $0.height.equalTo(36) }
        timeStackView.snp.makeConstraints { $0.height.equalTo(22) }
    }

    private func setupLabels() {
        currentTimeLabel.text = "00:00:00"
        currentTimeLabel.font = .systemFont(ofSize: 12)
        currentTimeLabel.textColor = .lightGray
        // FIXME: Find out if it's necessary
//        currentTimeLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)

        durationLabel.text = "--:--:--"
        durationLabel.textAlignment = .right
        durationLabel.font = .systemFont(ofSize: 12)
        durationLabel.textColor = .lightGray
    }
}
