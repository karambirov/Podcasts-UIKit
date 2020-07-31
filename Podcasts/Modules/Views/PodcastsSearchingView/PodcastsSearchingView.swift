//
//  PodcastsSearchingView.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 21/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit

final class PodcastsSearchingView: UIView {

    // MARK: - Properties
    private lazy var activityIndicatorView = UIActivityIndicatorView(style: .large)
    private lazy var textLabel = UILabel()
    private lazy var stackView = UIStackView(arrangedSubviews: [activityIndicatorView, textLabel])

    // MARK: - Life cycle
    override func didMoveToSuperview() {
        setupViews()
    }
}

// MARK: - Setup views
extension PodcastsSearchingView {

    private func setupViews() {
        setupActivityIndicatorView()
        setupLabel()
        setupLayout()
    }

    private func setupActivityIndicatorView() {
        activityIndicatorView.startAnimating()
        activityIndicatorView.color = .darkGray
    }

    private func setupLabel() {
        textLabel.numberOfLines = 0
        textLabel.textColor = AppConfig.tintColor
        textLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        textLabel.text = "Currently searching, please wait"
        textLabel.textAlignment = .center
    }

    private func setupLayout() {
        stackView.spacing = 12
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
        }
    }
}
