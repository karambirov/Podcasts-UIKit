//
//  PodcastCell.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 21/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit
import SDWebImage

final class PodcastCell: UITableViewCell {

    // MARK: - Properties
    fileprivate lazy var podcastImageView  = UIImageView()
    fileprivate lazy var trackNameLabel    = UILabel()
    fileprivate lazy var artistNameLabel   = UILabel()
    fileprivate lazy var episodeCountLabel = UILabel()

    // MARK: - Properties
    var podcast: Podcast? {
        didSet {
            trackNameLabel.text = podcast?.trackName
            artistNameLabel.text = podcast?.artistName
            episodeCountLabel.text = "\(podcast?.trackCount ?? 0) Episodes"

            guard let url = URL(string: podcast?.artworkUrl600 ?? "") else { return }
            podcastImageView.sd_setImage(with: url)
        }
    }

}
