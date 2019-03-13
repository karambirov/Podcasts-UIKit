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
    fileprivate lazy var activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    fileprivate lazy var textLabel             = UILabel()
    fileprivate lazy var stackView             = UIStackView(arrangedSubviews: [activityIndicatorView, textLabel])

    // MARK: - Life cycle
    override func didMoveToSuperview() {
        setupViews()
    }

}

// MARK: - Setup views
extension PodcastsSearchingView {

    fileprivate func setupViews() {
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
        textLabel.textColor = R.color.tintColor()
        textLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        textLabel.text = "Currently searching, please wait"
        textLabel.textAlignment = .center
    }

    private func setupLayout() {
        stackView.spacing = 12
        stackView.axis = .vertical
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
        }
    }

}
