//
//  PodcastCell.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 21/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

final class PodcastCell: UITableViewCell {

    // MARK: - Properties
    var viewModel: PodcastCellViewModel?

    fileprivate lazy var podcastImageView  = UIImageView()
    fileprivate lazy var trackNameLabel    = UILabel()
    fileprivate lazy var artistNameLabel   = UILabel()
    fileprivate lazy var episodeCountLabel = UILabel()

    // MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.podcast.observer = nil
    }

}

extension PodcastCell {

    func setup(with viewModel: PodcastCellViewModel) {
        self.viewModel = viewModel
        let podcast = viewModel.podcast.value

        trackNameLabel.text    = podcast?.trackName
        artistNameLabel.text   = podcast?.artistName
        episodeCountLabel.text = "\(podcast?.trackCount ?? 0) Episodes"

        viewModel.podcast.bind { [weak self] podcast in
            guard let self = self else { return }
            self.trackNameLabel.text    = podcast?.trackName
            self.artistNameLabel.text   = podcast?.artistName
            self.episodeCountLabel.text = "\(podcast?.trackCount ?? 0) Episodes"

            self.podcastImageView.sd_setImage(with: self.viewModel?.podcastImageURL)
        }

        setNeedsLayout()
    }

    func setupViews() {
        self.accessoryType = .disclosureIndicator
        setupLabels()
        setupLayout()
    }

    fileprivate func setupLabels() {
        trackNameLabel.numberOfLines = 0
        trackNameLabel.font = .boldSystemFont(ofSize: 17)
        artistNameLabel.numberOfLines = 0
        artistNameLabel.font = .systemFont(ofSize: 15)
        episodeCountLabel.textColor = UIColor(white: 0.5, alpha: 1.0)
        episodeCountLabel.font = .systemFont(ofSize: 15)
    }

    fileprivate func setupLayout() {
        self.addSubview(podcastImageView)
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
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(self.snp.trailingMargin)
            make.leading.equalTo(podcastImageView.snp.trailing).offset(12)
        }
    }

}
