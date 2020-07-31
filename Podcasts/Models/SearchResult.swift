//
//  SearchResult.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 24/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {

    let resultCount: Int
    let results: [Podcast]
}
