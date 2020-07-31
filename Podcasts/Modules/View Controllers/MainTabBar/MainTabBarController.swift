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
    private let viewModel: MainTabBarViewModel
//    private let playerDetailsView = PlayerDetailsView.initFromNib()

    // swiftlint:disable implicitly_unwrapped_optional
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    // swiftlint:enable implicitly_unwrapped_optional

    // MARK: - View Controller's life cycle
    init(viewModel: MainTabBarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

	@available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        set(items: viewModel.items)
//        setupPlayerDetailsView()
    }
}

// MARK: - Setup
extension MainTabBarController {
//    @objc
//    func minimizePlayerDetails() {
//        maximizedTopAnchorConstraint.isActive = false
//        bottomAnchorConstraint.constant = view.frame.height
//        minimizedTopAnchorConstraint.isActive = true
//
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7,
//                       initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//
//            self.view.layoutIfNeeded()
//            self.tabBar.transform = .identity
//            self.playerDetailsView.maximizedStackView.alpha = 0
//            self.playerDetailsView.miniPlayerView.alpha = 1
//        })
//    }
//
//    func maximizePlayerDetails(for episode: Episode?, playlistEpisodes: [Episode] = []) {
//        minimizedTopAnchorConstraint.isActive = false
//        maximizedTopAnchorConstraint.isActive = true
//        maximizedTopAnchorConstraint.constant = 0
//        bottomAnchorConstraint.constant = 0
//
//        if episode != nil {
//            playerDetailsView.episode = episode
//        }
//
//        playerDetailsView.playlistEpisodes = playlistEpisodes
//
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7,
//                       initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//
//            self.view.layoutIfNeeded()
//            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
//            self.playerDetailsView.maximizedStackView.alpha = 1
//            self.playerDetailsView.miniPlayerView.alpha = 0
//        })
//    }

    // MARK: - Private
    private func viewController(for itemType: MainTabBarViewModel.TabBarItem) -> UIViewController {
        let controller = itemType.viewController
        return controller
    }

    private func set(items: [MainTabBarViewModel.TabBarItem]) {
        guard viewControllers?.count != items.count else { return }
        viewControllers = items.map { viewController(for: $0) }
    }

//    private func setupPlayerDetailsView() {
//        view.insertSubview(playerDetailsView, belowSubview: tabBar)
//        setupConstraintsForPlayerDetailsView()
//    }

//    private func setupConstraintsForPlayerDetailsView() {
//        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
//
//        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor,
//                                                                              constant: view.frame.height)
//        maximizedTopAnchorConstraint.isActive = true
//
//        bottomAnchorConstraint = playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
//                                                                           constant: view.frame.height)
//        bottomAnchorConstraint.isActive = true
//
//        minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
//
//        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//    }
}
