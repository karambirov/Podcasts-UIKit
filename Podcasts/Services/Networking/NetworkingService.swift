//
//  NetworkingService.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 11/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Moya
import Alamofire
import FeedKit

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
                } catch let decodingError {
                    print("Failed to decode:", decodingError)
                }

            case .failure(let error):
                print(error.errorDescription ?? "")
            }
        }
    }

}

// MARK: - Fetching episodes
extension NetworkingService {

    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> Void) {
        guard let url = URL(string: feedUrl.httpsUrlString) else { return }

        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)

            parser?.parseAsync(result: { result in
                print("Successfully parse feed:", result.isSuccess)

                if let error = result.error {
                    print("Failed to parse XML feed:", error)
                    return
                }

                guard let feed = result.rssFeed else { return }
                let episodes = feed.toEpisodes()
                completionHandler(episodes)
            })
        }
    }

}

// MARK: - Downloading episodes
extension NetworkingService {

    typealias EpisodeDownloadComplete = (fileUrl: String, episodeTitle: String)

    func downloadEpisode(_ episode: Episode) {
        print("Downloading episode using Alamofire at stream url:", episode.streamUrl)

        let downloadRequest = DownloadRequest.suggestedDownloadDestination()

        Alamofire.download(episode.streamUrl, to: downloadRequest).downloadProgress { progress in
            NotificationCenter.default.post(name: .downloadProgress, object: nil,
                                            userInfo: ["title": episode.title, "progress": progress.fractionCompleted])
            }.response { response in
                print(response.destinationURL?.absoluteString ?? "")

                let episodeDownloadComplete = EpisodeDownloadComplete(fileUrl: response.destinationURL?.absoluteString ?? "",
                                                                      episode.title)
                NotificationCenter.default.post(name: .downloadComplete, object: episodeDownloadComplete, userInfo: nil)

                var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes
                guard let index = downloadedEpisodes.firstIndex(where: { $0.title == episode.title
                                                                && $0.author == episode.author }) else { return }
                downloadedEpisodes[index].fileUrl = response.destinationURL?.absoluteString ?? ""

                do {
                    let data = try JSONEncoder().encode(downloadedEpisodes)
                    UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
                } catch let downloadingError {
                    print("Failed to encode downloaded episodes with file url update:", downloadingError)
                }
        }
    }
}
