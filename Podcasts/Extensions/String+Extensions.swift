//
//  String+Extensions.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 25/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import Foundation

extension String {

    var httpsUrlString: String {
        contains("https") ? self : replacingOccurrences(of: "http", with: "https")
    }

    var urlEscapedString: String {
        // swiftlint:disable:next force_unwrapping
        addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}
