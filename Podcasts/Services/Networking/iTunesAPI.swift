//
//  iTunesAPI.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 11/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Moya
import Foundation

enum ITunesAPI {
    case search(term: String)
}

extension ITunesAPI: TargetType {

    var baseURL: URL {
        guard let url = URL(string: "https://itunes.apple.com/") else {
            fatalError("Error in base url: https://itunes.apple.com/")
        }
        return url
    }

    var path: String {
        switch self {
        case .search:
            return "/search"
        }
    }

	var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .search(let term):
            let parameters = ["term": term.URLEscapedString, "media": "podcast"]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }

}
