//
//  EpisodeCell.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 25/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit
import SnapKit

final class EpisodeCell: UITableViewCell {

    // MARK: - Properties
    var viewModel: EpisodeCellViewModel?

    fileprivate lazy var episodeImageView = UIImageView()
    fileprivate lazy var progressLabel    = UILabel()
    fileprivate lazy var pubDateLabel     = UILabel()
    fileprivate lazy var titleLabel       = UILabel()
    fileprivate lazy var descriptionLabel = UILabel()

    var episode: Episode? {
        didSet {

        }
    }

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
        viewModel?.episode.observer = nil
    }

}

extension EpisodeCell {

    func setup(with viewModel: EpisodeCellViewModel) {
        self.viewModel = viewModel
        let episode = viewModel.episode.value

        titleLabel.text        = episode?.title
        descriptionLabel.text  = episode?.description
        pubDateLabel.text      = viewModel.pubDate

        viewModel.episode.bind { [weak self] episode in
            guard let self = self else { return }
            self.titleLabel.text        = episode?.title
            self.descriptionLabel.text  = episode?.description
            self.pubDateLabel.text      = viewModel.pubDate

            self.episodeImageView.sd_setImage(with: self.viewModel?.episodeImageURL)
        }

        setNeedsLayout()
    }

    func setupViews() {
        self.accessoryType = .disclosureIndicator
        setupLabels()
        setupLayout()
    }

    fileprivate func setupLabels() {
        titleLabel.numberOfLines = 0
        titleLabel.font = .boldSystemFont(ofSize: 17)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 15)
        pubDateLabel.textColor = UIColor(white: 0.5, alpha: 1.0)
        pubDateLabel.font = .systemFont(ofSize: 15)
    }

    fileprivate func setupLayout() {
        self.addSubview(episodeImageView)
        episodeImageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.leading.equalTo(self.snp.leadingMargin)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }

        self.addSubview(progressLabel)
        progressLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(episodeImageView.snp.center)
        }

        let stackView = UIStackView(arrangedSubviews: [pubDateLabel, titleLabel, descriptionLabel])
        stackView.spacing = 4
        stackView.axis = .vertical
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(self.snp.trailingMargin)
            make.leading.equalTo(episodeImageView.snp.trailing).offset(12)
        }
    }


}
