//
//  TableViewDataSource.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 22/02/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import UIKit

final class TableViewDataSource<Model, Cell: UITableViewCell>: NSObject, UITableViewDataSource {

    typealias CellConfigurator = (Model, Cell) -> Void

    var models: [Model] = []

    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator

    init(models: [Model], reuseIdentifier: String, cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell: Cell = tableView.dequeueCell(withIdentifier: reuseIdentifier, for: indexPath)
        cellConfigurator(model, cell)
        return cell
    }
}

extension TableViewDataSource where Model == Podcast {
    static func make(
        for podcasts: [Podcast],
        reuseIdentifier: String = PodcastCell.typeName
    ) -> TableViewDataSource {
        TableViewDataSource(
            models: podcasts,
            reuseIdentifier: reuseIdentifier,
            cellConfigurator: { podcast, cell in
                let cellViewModel = PodcastCellViewModel(podcast: podcast)
                if let cell = cell as? PodcastCell {
                    cell.setup(with: cellViewModel)
                }
                cell.layoutIfNeeded()
            }
        )
    }
}

extension TableViewDataSource where Model == Episode {
    static func make(
        for episodes: [Episode],
        reuseIdentifier: String = EpisodeCell.typeName
    ) -> TableViewDataSource {
        TableViewDataSource(
            models: episodes,
            reuseIdentifier: reuseIdentifier,
            cellConfigurator: { episode, cell in
                let cellViewModel = EpisodeCellViewModel(episode: episode)
                if let cell = cell as? EpisodeCell {
                    cell.setup(with: cellViewModel)
                }
                cell.layoutIfNeeded()
            }
        )
    }
}
