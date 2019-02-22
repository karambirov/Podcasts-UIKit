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
    var podcast: Podcast! {
        didSet {
            nameLabel.text       = podcast.trackName
            artistNameLabel.text = podcast.artistName

            let url = URL(string: podcast.artworkUrl600?.httpsUrlString ?? "")
            imageView.sd_setImage(with: url)
        }
    }

    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "appicon"))
    fileprivate let nameLabel = UILabel()
    fileprivate let artistNameLabel = UILabel()

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


// MARK: - Setup
extension FavoritePodcastCell {

    fileprivate func setupViews() {
        stylizeUI()

        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true

        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, artistNameLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    private func stylizeUI() {
        nameLabel.text = "Podcast Name"
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        artistNameLabel.text = "Artist Name"
        artistNameLabel.font = UIFont.systemFont(ofSize: 14)
        artistNameLabel.textColor = .lightGray
    }

}
