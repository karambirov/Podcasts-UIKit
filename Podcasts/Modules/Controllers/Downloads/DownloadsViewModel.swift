//
//  DownloadsViewModel.swift
//  Podcasts
//
//  Created by Timur Rakhimov on 23/02/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Foundation

final class DownloadsViewModel {
    
    // MARK: - Properties
    let reuseIdentifier = "EpisodeCell" 
    var episodes = UserDefaults.standard.downloadedEpisodes
    
}
