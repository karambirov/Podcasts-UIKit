//
//  MainTabBarController.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 21/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit

final class MainTabBarController: UITabBarController {

    // MARK: - Properties
    fileprivate let playerDetailsView = PlayerDetailsView.initFromNib()
    fileprivate var maximizedTopAnchorConstraint: NSLayoutConstraint!
    fileprivate var minimizedTopAnchorConstraint: NSLayoutConstraint!
    fileprivate var bottomAnchorConstraint: NSLayoutConstraint!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple

        setupViewControllers()
        setupPlayerDetailsView()
    }

}


// MARK: - Setup
extension MainTabBarController {

    fileprivate func setupViewControllers() {
        let layout = UICollectionViewFlowLayout()
        let favoritesController = FavoritesController(collectionViewLayout: layout)

        viewControllers = [
            generateNavigationController(for: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search")),
            generateNavigationController(for: favoritesController, title: "Favorites", image: #imageLiteral(resourceName: "favorites")),
            generateNavigationController(for: DownloadsController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        ]
    }

    fileprivate func setupPlayerDetailsView() {
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        setupConstraintsForPlayerDetailsView()
    }

    fileprivate func generateNavigationController(for rootViewController: UIViewController,
                                                  title: String, image: UIImage) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navigationController.tabBarItem.title   = title
        navigationController.tabBarItem.image   = image
        return navigationController
    }

    @objc func minimizePlayerDetails() {
        fatalError("Need implementation \(#function)")
    }

    private func setupConstraintsForPlayerDetailsView() {
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false

        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor,
                                                                              constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true

        bottomAnchorConstraint = playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                           constant: view.frame.height)
        bottomAnchorConstraint.isActive = true

        minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)

        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

}
