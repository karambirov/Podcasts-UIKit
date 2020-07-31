//
//  CollectionViewDataSource.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 22/02/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import UIKit

final class CollectionViewDataSource<Model, Cell: UICollectionViewCell>: NSObject, UICollectionViewDataSource {

    typealias CellConfigurator = (Model, Cell) -> Void

    var models: [Model] = []

    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator

    init(models: [Model], reuseIdentifier: String, cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.item]
        let cell: Cell = collectionView.dequeueCell(withIdentifier: reuseIdentifier, for: indexPath)
        cellConfigurator(model, cell)
        return cell
    }

}

extension CollectionViewDataSource where Model == Podcast {

    static func make(
        for podcasts: [Podcast],
        reuseIdentifier: String = FavoritePodcastCell.typeName) -> CollectionViewDataSource
    {

        CollectionViewDataSource(
            models: podcasts,
            reuseIdentifier: reuseIdentifier,
            cellConfigurator: { podcast, cell in
                let cellViewModel = FavoritePodcastCellViewModel(podcast: podcast)
                if let cell = cell as? FavoritePodcastCell {
                    cell.setup(with: cellViewModel)
                }
                cell.layoutIfNeeded()
            })

    }

}
