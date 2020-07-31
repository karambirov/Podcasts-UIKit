//
//  PodcastCell.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 21/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import SnapKit
import UIKit

final class PodcastCell: UITableViewCell {

    // MARK: - Properties
    var viewModel: PodcastCellViewModel?

    private lazy var podcastImageView = UIImageView()
    private lazy var trackNameLabel = UILabel()
    private lazy var artistNameLabel = UILabel()
    private lazy var episodeCountLabel = UILabel()

    // MARK: - Life cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.podcast.observer = nil
    }
}

// MARK: - Setup
extension PodcastCell {

    func setup(with viewModel: PodcastCellViewModel) {
        self.viewModel = viewModel
        let podcast = viewModel.podcast.value

        trackNameLabel.text = podcast?.trackName
        artistNameLabel.text = podcast?.artistName
        episodeCountLabel.text = "\(podcast?.trackCount ?? 0) Episodes"

        viewModel.podcast.bind { [weak self] podcast in
            guard let self = self else { return }
            self.trackNameLabel.text = podcast?.trackName
            self.artistNameLabel.text = podcast?.artistName
            self.episodeCountLabel.text = "\(podcast?.trackCount ?? 0) Episodes"
            self.podcastImageView.setImage(from: self.viewModel?.podcastImageURL)
        }

        setupViews()
        setNeedsLayout()
    }

    private func setupViews() {
        accessoryType = .disclosureIndicator
        setupLabels()
        setupLayout()
    }

    private func setupLabels() {
        trackNameLabel.numberOfLines = 0
        trackNameLabel.font = .boldSystemFont(ofSize: 17)
        artistNameLabel.numberOfLines = 0
        artistNameLabel.font = .systemFont(ofSize: 15)
        episodeCountLabel.textColor = UIColor(white: 0.5, alpha: 1.0)
        episodeCountLabel.font = .systemFont(ofSize: 15)
    }

    private func setupLayout() {
        addSubview(podcastImageView)
        podcastImageView.contentMode = .scaleAspectFit
        podcastImageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.leading.equalTo(self.snp.leadingMargin)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }

        let stackView = UIStackView(arrangedSubviews: [trackNameLabel, artistNameLabel, episodeCountLabel])
        stackView.spacing = 4
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(self.snp.trailingMargin)
            make.leading.equalTo(podcastImageView.snp.trailing).offset(12)
        }
    }
}
