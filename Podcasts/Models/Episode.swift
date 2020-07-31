//
//  Episode.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 25/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import FeedKit
import Foundation

struct Episode: Codable {

    let title: String
    let pubDate: Date
    let description: String
    let author: String
    let streamUrl: String

    var fileUrl: String?
    var imageUrl: String?

    init(feedItem: RSSFeedItem) {
        streamUrl = feedItem.enclosure?.attributes?.url ?? ""
        title = feedItem.title ?? ""
        pubDate = feedItem.pubDate ?? Date()
        description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        author = feedItem.iTunes?.iTunesAuthor ?? ""
        imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
    }
}
