//
//  FavoritePodcastCell.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 28/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit

final class FavoritePodcastCell: UICollectionViewCell {

    // MARK: - Properties
    var viewModel: FavoritePodcastCellViewModel?

    fileprivate lazy var imageView =  UIImageView(image: R.image.appicon())
    fileprivate lazy var nameLabel = UILabel()
    fileprivate lazy var artistNameLabel = UILabel()

    // MARK: - Life cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.podcast.observer = nil
    }

}

// MARK: - Setup
extension FavoritePodcastCell {

    func setup(with viewModel: FavoritePodcastCellViewModel) {
        self.viewModel = viewModel
        let podcast = viewModel.podcast.value

        nameLabel.text       = podcast?.trackName
        artistNameLabel.text = podcast?.artistName

        viewModel.podcast.bind { [weak self] podcast in
            guard let self = self else { return }
            self.nameLabel.text         = podcast?.trackName
            self.artistNameLabel.text   = podcast?.artistName
            self.imageView.setImage(from: self.viewModel?.podcastImageURL)
        }

        setupViews()
        setNeedsLayout()
    }

    private func setupViews() {
        setupLabels()
        setupLayout()
    }

    private func setupLabels() {
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        artistNameLabel.numberOfLines = 0
        artistNameLabel.font = UIFont.systemFont(ofSize: 14)
        artistNameLabel.textColor = UIColor(white: 0.5, alpha: 1.0)
    }

    private func setupLayout() {
        self.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.leading.equalTo(self.snp.leadingMargin)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }

        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, artistNameLabel])
        stackView.spacing = 4
        stackView.axis = .vertical
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(self.snp.trailingMargin)
            make.leading.equalTo(imageView.snp.trailing).offset(12)
        }
    }

}
