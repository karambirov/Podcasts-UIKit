//
//  TabBarViewModel.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 01.08.2020.
//  Copyright © 2020 Eugene Karambirov. All rights reserved.
//

import UIKit

struct TabBarViewModel {

    private let viewControllers: [UIViewController]
    private let playerService: PlayerService

    init(viewControllers: [UIViewController], playerService: PlayerService) {
        self.viewControllers = viewControllers
        self.playerService = playerService
    }
}
