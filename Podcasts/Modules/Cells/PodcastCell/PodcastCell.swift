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

    // MARK: - Outlets
    @IBOutlet fileprivate weak var podcastImageView: UIImageView!
    @IBOutlet fileprivate weak var trackNameLabel: UILabel!
    @IBOutlet fileprivate weak var artistNameLabel: UILabel!
    @IBOutlet fileprivate weak var episodeCountLabel: UILabel!

    // MARK: - Properties
    // maybe force-unwrapping?
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
