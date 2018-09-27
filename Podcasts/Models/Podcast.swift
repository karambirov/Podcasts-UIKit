//
//  Podcast.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 21/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import Foundation

final class Podcast: NSObject, Decodable, NSCoding {

    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?


    func encode(with aCoder: NSCoder) {
        print("\n\t\tTrying to transform Podcast into Data")
        aCoder.encode(trackName ?? "", forKey: "trackNameKey")
        aCoder.encode(artistName ?? "", forKey: "artistNameKey")
        aCoder.encode(artworkUrl600 ?? "", forKey: "artworkKey")
        aCoder.encode(feedUrl ?? "", forKey: "feedKey")
    }

    init?(coder aDecoder: NSCoder) {
        print("\n\t\tTrying to turn Data into Podcast")
        self.trackName     = aDecoder.decodeObject(forKey: "trackNameKey") as? String
        self.artistName    = aDecoder.decodeObject(forKey: "artistNameKey") as? String
        self.artworkUrl600 = aDecoder.decodeObject(forKey: "artworkKey") as? String
        self.feedUrl       = aDecoder.decodeObject(forKey: "feedKey") as? String
    }

}
