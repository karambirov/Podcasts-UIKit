//
//  FavoritesController.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 21/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

final class FavoritesController: UICollectionViewController {

    // MARK: - Properties
    fileprivate var podcasts = UserDefaults.standard.savedPodcasts

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        podcasts = UserDefaults.standard.savedPodcasts
        collectionView?.reloadData()
        UIApplication.mainTabBarController?.viewControllers?[1].tabBarItem.badgeValue = nil
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesController: UICollectionViewDelegateFlowLayout {
    
}


// MARK: - Setup
extension FavoritesController {

    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(gesture)
    }

    @objc private func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        guard let selectedIndexPath = collectionView?.indexPathForItem(at: location) else { return }
        print(selectedIndexPath.item)

        let alertController = UIAlertController(title: "Remove podcast?", message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            let selectedPodcast = self.podcasts[selectedIndexPath.item]
            self.podcasts.remove(at: selectedIndexPath.item)
            self.collectionView?.deleteItems(at: [selectedIndexPath])
            UserDefaults.standard.deletePodcast(podcast: selectedPodcast)
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alertController, animated: true)
    }

}
