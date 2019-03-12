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

        self.addSubview(podcastImageView)
        podcastImageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
        }

        let stackView = UIStackView(arrangedSubviews: [trackNameLabel, artistNameLabel, episodeCountLabel])
        stackView.spacing = 2
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(8)
            make.leading.equalTo(podcastImageView).offset(12)
        }
    }

}
