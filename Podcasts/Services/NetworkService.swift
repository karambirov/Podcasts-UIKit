//
//  NetworkService.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 24/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

final class NetworkService {

    typealias EpisodeDownloadComplete = (fileUrl: String, episodeTitle: String)

    fileprivate let baseiTunesSearchURL = "https://itunes.apple.com/search"

    static let shared = NetworkService()

}


// MARK: - Fetching podcasts
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


// MARK: - Fetching episodes
extension NetworkService {

    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> Void) {
        guard let url = URL(string: feedUrl.httpsUrlString) else { return }

        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)

            parser?.parseAsync(result: { result in
                print("\n\t\tSuccessfully parse feed:", result.isSuccess)

                if let error = result.error {
                    print("\n\t\tFailed to parse XML feed:", error)
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
extension NetworkService {

    func downloadEpisode(_ episode: Episode) {
        print("\n\t\tDownloading episode using Alamofire at stream url:", episode.streamUrl)

        let downloadRequest = DownloadRequest.suggestedDownloadDestination()

        Alamofire.download(episode.streamUrl, to: downloadRequest).downloadProgress { progress in
            NotificationCenter.default.post(name: .downloadProgress,
                                            object: nil,
                                            userInfo: ["title": episode.title, "progress": progress.fractionCompleted])
            }.response { response in
                print("\n\t\t", response.destinationURL?.absoluteString ?? "")

                let episodeDownloadComplete = EpisodeDownloadComplete(fileUrl: response.destinationURL?.absoluteString ?? "", episode.title)
                NotificationCenter.default.post(name: .downloadComplete, object: episodeDownloadComplete, userInfo: nil)

                var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes
                guard let index = downloadedEpisodes.firstIndex(where: { $0.title == episode.title &&
                                                                         $0.author == episode.author }) else { return }
                downloadedEpisodes[index].fileUrl = response.destinationURL?.absoluteString ?? ""

                do {
                    let data = try JSONEncoder().encode(downloadedEpisodes)
                    UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
                } catch let error {
                    print("\n\t\tFailed to encode downloaded episodes with file url update:", error)
                }
        }
    }

}
