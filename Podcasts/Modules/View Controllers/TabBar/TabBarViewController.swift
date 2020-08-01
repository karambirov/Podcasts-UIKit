//
//  TabBarViewController.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 01.08.2020.
//  Copyright © 2020 Eugene Karambirov. All rights reserved.
//

import UIKit

final class TabBarViewController: UITabBarController {

    private let viewModel: TabBarViewModel

    init(viewModel: TabBarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
