//
//  NetworkService.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 24/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import Foundation
import Alamofire

final class NetworkService {

    fileprivate let baseiTunesSearchURL = "https://itunes.apple.com/search"

    static let shared = NetworkService()

}

extension NetworkService {

    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> Void) {
        print("\n\t\tSearching for podcasts...")

        let parameters = ["term": searchText, "media": "podcast"]

        Alamofire.request(baseiTunesSearchURL,
                          method: .get,
                          parameters: parameters,
                          encoding: URLEncoding.default,
                          headers: nil).responseData { dataResponse in

            if let error = dataResponse.error {
                print("\n\t\tFailed with error:", error)
                return
            }

            guard let data = dataResponse.data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completionHandler(searchResult.results)
            } catch let decodeError {
                print("\n\t\tFailed to decode:", decodeError)
            }

        }
    }

}
