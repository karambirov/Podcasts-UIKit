//
//  FavoritesController.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 21/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit

final class FavoritesViewController: UICollectionViewController {

    // MARK: - Properties
    fileprivate let viewModel: FavoritesViewModel

    // MARK: - View Controller's life cycle
    init(viewModel: FavoritesViewModel,
         collectionViewLayout: UICollectionViewLayout = UICollectionViewFlowLayout()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()

        viewModel.fetchFavorites { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshFavorites()
    }

}

// MARK: - Collection View
extension FavoritesViewController {

    // MARK: - Navigation
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let podcast = viewModel.podcast(for: indexPath)
        let episodesViewModel  = EpisodesViewModel(podcast: podcast)
        let episodesController = EpisodesViewController(viewModel: episodesViewModel)
        navigationController?.pushViewController(episodesController, animated: true)
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3 * 16) / 2
        return CGSize(width: width, height: width + 46)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

}

// MARK: - Setup
extension FavoritesViewController {

    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        let nib = UINib(resource: R.nib.favoritePodcastCell)
        collectionView.register(nib, forCellWithReuseIdentifier: FavoritePodcastCell.typeName)
        collectionView.dataSource = viewModel.dataSource

        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(gesture)
    }

    fileprivate func refreshFavorites() {
        viewModel.podcasts = UserDefaults.standard.savedPodcasts
        collectionView?.reloadData()
        UIApplication.mainTabBarController?.viewControllers?[1].tabBarItem.badgeValue = nil
    }

    @objc private func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        guard let selectedIndexPath = collectionView?.indexPathForItem(at: location) else { return }
        print(selectedIndexPath.item)
        presentAlert(with: "Remove podcast?", for: selectedIndexPath)
    }

    private func presentAlert(with title: String, for indexPath: IndexPath) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            self.viewModel.deletePodcast(for: indexPath)
            self.collectionView?.deleteItems(at: [indexPath])
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alertController, animated: true)
    }

}
