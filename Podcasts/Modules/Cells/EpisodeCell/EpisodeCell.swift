//
//  EpisodeCell.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 25/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit

final class EpisodeCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    // MARK: - Properties
    var episode: Episode? {
        didSet {
            titleLabel.text = episode?.title
            descriptionLabel.text = episode?.description

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            pubDateLabel.text = dateFormatter.string(from: episode?.pubDate ?? Date())

            let url = URL(string: episode?.imageUrl?.httpsUrlString ?? "")
            episodeImageView.sd_setImage(with: url)
        }
    }

}
