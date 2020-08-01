//
//  NetworkingService.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 11/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Alamofire
import FeedKit
import Foundation
import Moya

final class NetworkingService {

    private var provider: MoyaProvider<ITunesAPI>?
    private var podcastsService: PodcastsService?

    init(
        provider: MoyaProvider<ITunesAPI> = .init(),
        podcastsService: PodcastsService = .init()
    ) {
        self.provider = provider
        self.podcastsService = podcastsService
    }
}

// MARK: - Fetching podcasts
extension NetworkingService {

    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> Void) {
        provider?.request(.search(term: searchText)) { result in
            switch result {
            case let .success(response):
                do {
                    let searchResult = try response.map(SearchResult.self)
                    DispatchQueue.main.async {
                        completionHandler(searchResult.results)
                    }
                } catch let decodingError {
                    print("Failed to decode:", decodingError)
                }

            case let .failure(error):
                print(error.errorDescription ?? "")
            }
        }
    }
}

// MARK: - Fetching episodes
extension NetworkingService {

    func fetchEpisodes(feedUrlSting: String?, completionHandler: @escaping ([Episode]) -> Void) {
        guard
            let feedUrlSting = feedUrlSting,
            let url = URL(string: feedUrlSting.httpsUrlString)
        else { return }

        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)

            parser.parseAsync { result in
                switch result {
                case let .success(feed):
                    print("Successfully parse feed:", feed)
                    guard let rssFeed = feed.rssFeed else { return }
                    let episodes = rssFeed.toEpisodes()
                    DispatchQueue.main.async {
                        completionHandler(episodes)
                    }
                case let .failure(parserError):
                    print("Failed to parse XML feed:", parserError)
                }
            }
        }
    }
}

// MARK: - Downloading episodes
extension NetworkingService {

    typealias EpisodeDownloadComplete = (fileUrl: String, episodeTitle: String)

    func downloadEpisode(_ episode: Episode) {
        print("Downloading episode using Alamofire at stream url:", episode.streamUrl)

        let downloadRequest = DownloadRequest.suggestedDownloadDestination()

        AF.download(episode.streamUrl, to: downloadRequest).downloadProgress { progress in
            NotificationCenter.default.post(
                name: .downloadProgress,
                object: nil,
                userInfo: ["title": episode.title, "progress": progress.fractionCompleted]
            )
        }.response { response in
            print(response.fileURL?.absoluteString ?? "")

            let episodeDownloadComplete = EpisodeDownloadComplete(
                fileUrl: response.fileURL?.absoluteString ?? "",
                episode.title
            )
            NotificationCenter.default.post(name: .downloadComplete, object: episodeDownloadComplete, userInfo: nil)

            var downloadedEpisodes = self.podcastsService?.downloadedEpisodes
            guard let index = downloadedEpisodes?.firstIndex(where: { $0.title == episode.title
                    && $0.author == episode.author
            }) else { return }
            downloadedEpisodes?[index].fileUrl = response.fileURL?.absoluteString ?? ""

            do {
                let data = try JSONEncoder().encode(downloadedEpisodes)
                UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
            } catch let downloadingError {
                print("Failed to encode downloaded episodes with file url update:", downloadingError)
            }
        }
    }
}
