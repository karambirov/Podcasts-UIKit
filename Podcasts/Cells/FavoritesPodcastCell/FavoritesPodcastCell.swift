//
//  FavoritesPodcastCell.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 28/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit

final class FavoritesPodcastCell: UICollectionViewCell {

    // MARK: - Properties
    var podcast: Podcast! {
        didSet {

        }
    }

    // MARK: - Outlets


    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        stylizeUI()
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


// MARK: - Setup
extension FavoritesPodcastCell {

    fileprivate func stylizeUI() {

    }

    fileprivate func setupViews() {

    }

}
