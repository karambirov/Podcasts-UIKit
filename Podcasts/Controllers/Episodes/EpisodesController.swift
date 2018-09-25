//
//  EpisodesController.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 25/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit

// TODO: Replase strings with type-safety values
final class EpisodesController: UITableViewController {

    // MARK: - Properties
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName

            fetchEpisodes()
        }
    }

    var episodes = [Episode]()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

}

// MARK: - UITableView
extension EpisodesController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCell
        cell.episode = episodes[indexPath.row]
        return cell
    }

}


// MARK: - Setup
extension EpisodesController {

    fileprivate func initialSetup() {
        setupTableView()
        setupNavigationBarButtons()
    }

    private func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "EpisodeCell")
        tableView.tableFooterView = UIView()
        self.clearsSelectionOnViewWillAppear = false
    }

    private func setupNavigationBarButtons() {

    }

    fileprivate func fetchEpisodes() {
        print("\n\t\tLooking for episodes at feed url:", podcast?.feedUrl ?? "")

        guard let feedURL = podcast?.feedUrl else { return }
        // TODO: Fetch episodes
    }

}
