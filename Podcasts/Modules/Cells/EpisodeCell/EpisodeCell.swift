//
//  EpisodeCell.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 25/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import SnapKit
import UIKit

final class EpisodeCell: UITableViewCell {

    // MARK: - Properties
    var viewModel: EpisodeCellViewModel?

    private lazy var episodeImageView = UIImageView()
    // TODO: - Handle progress text using view model
    lazy var progressLabel = UILabel()
    private lazy var pubDateLabel = UILabel()
    private lazy var titleLabel = UILabel()
    private lazy var descriptionLabel = UILabel()

    // MARK: - Life cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.episode.observer = nil
    }
}

// MARK: - Setup
extension EpisodeCell {

    func setup(with viewModel: EpisodeCellViewModel) {
        self.viewModel = viewModel
        let episode = viewModel.episode.value

        titleLabel.text = episode?.title
        descriptionLabel.text = episode?.description
        pubDateLabel.text = viewModel.pubDate

        viewModel.episode.bind { [weak self] episode in
            guard let self = self else { return }
            self.titleLabel.text = episode?.title
            self.descriptionLabel.text = episode?.description
            self.pubDateLabel.text = viewModel.pubDate
            self.episodeImageView.setImage(from: self.viewModel?.episodeImageURL)
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
        titleLabel.numberOfLines = 0
        titleLabel.font = .boldSystemFont(ofSize: 17)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 15)
        pubDateLabel.textColor = UIColor(white: 0.5, alpha: 1.0)
        pubDateLabel.font = .systemFont(ofSize: 15)
    }

    private func setupLayout() {
        addSubview(episodeImageView)
        episodeImageView.contentMode = .scaleAspectFit
        episodeImageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.leading.equalTo(self.snp.leadingMargin)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }

        addSubview(progressLabel)
        progressLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(episodeImageView.snp.center)
        }

        let stackView = UIStackView(arrangedSubviews: [pubDateLabel, titleLabel, descriptionLabel])
        stackView.spacing = 4
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(self.snp.trailingMargin)
            make.leading.equalTo(episodeImageView.snp.trailing).offset(12)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
    }
}
