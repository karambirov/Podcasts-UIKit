//
//  NetworkingService.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 11/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Moya

final class NetworkingService {

    private var provider: MoyaProvider<ITunesAPI>?

    init(provider: MoyaProvider<ITunesAPI> = .init()) {
        self.provider = provider
    }

}

// MARK: - Fetching podcasts
extension NetworkingService {

    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> Void) {
        provider?.request(.search(term: searchText)) { result in
            switch result {
            case .success(let response):
                do {
                    let searchResult = try response.map(SearchResult.self)
                    completionHandler(searchResult.results)
                } catch let decodeError {
                    print("Failed to decode:", decodeError)
                }

            case .failure(let error):
                print(error)
            }
        }
    }

}

// MARK: - Fetching episodes
extension NetworkingService {
    
}
