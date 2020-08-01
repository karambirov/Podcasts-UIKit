//
//  TabBarAssembly.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 01.08.2020.
//  Copyright © 2020 Eugene Karambirov. All rights reserved.
//

import Foundation
import UIKit

struct TabBarAssembly: AssemblyProtocol {

    struct Dependencies {
        let playerService: PlayerService
    }

    struct Parameters {}

    func makeModule(dependencies: Dependencies, parameters: Parameters) -> UIViewController {

        let viewControllers = [
            makePodcastsSearchModule(dependencies: dependencies, parameters: parameters),
            makeFavoritesModule(dependencies: dependencies, parameters: parameters),
            makeDownloadsModule(dependencies: dependencies, parameters: parameters),
        ]

        return TabBarViewController(
            viewModel: TabBarViewModel(
                viewControllers: viewControllers,
                playerService: dependencies.playerService
            )
        )
    }
}

// TODO: Add assemblies to the modules
private extension TabBarAssembly {

    func makePodcastsSearchModule(dependencies: Dependencies, parameters: Parameters) -> UIViewController {
        let podcastsSearchViewModel = PodcastsSearchViewModel(networkingService: ServiceLocator.networkingService)
        let podcastsSearchViewController = PodcastsSearchViewController(viewModel: podcastsSearchViewModel)
        let controller = makeNavigationController(
            for: podcastsSearchViewController,
            title: "Search",
            image: UIImage(systemSymbol: .magnifyingglass)
        )
        return controller
    }

    func makeFavoritesModule(dependencies: Dependencies, parameters: Parameters) -> UIViewController {
        let favoritesViewModel = FavoritesViewModel(
            podcastsService: ServiceLocator.podcastsService,
            playerService: dependencies.playerService
        )
        let favoritesViewController = FavoritesViewController(viewModel: favoritesViewModel)
        let controller = makeNavigationController(
            for: favoritesViewController,
            title: "Favorites",
            image: UIImage(systemSymbol: .playCircleFill)
        )
        return controller
    }

    func makeDownloadsModule(dependencies: Dependencies, parameters: Parameters) -> UIViewController {
        let downloadsViewModel = DownloadsViewModel()
        let downloadsViewController = DownloadsViewController(viewModel: downloadsViewModel)
        let controller = makeNavigationController(
            for: downloadsViewController,
            title: "Downloads",
            image: UIImage(systemSymbol: .icloudAndArrowDownFill)
        )
        return controller
    }
}

private extension TabBarAssembly {

    func makeNavigationController(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage
    ) -> UIViewController {

        let navigationController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        return navigationController
    }
}
