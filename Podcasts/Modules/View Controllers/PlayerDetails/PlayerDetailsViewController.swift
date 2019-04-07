//
//  PlayerDetailsViewController.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 07/04/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    // MARK: - Properties
    fileprivate var viewModel: PlayerDetailsViewModel
    fileprivate lazy var playerView = PlayerStackView()

    // MARK: - View Controller's life cycle
    init(viewModel: PlayerDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

}

// MARK: - Setup
extension PlayerViewController {

    fileprivate func initialSetup() {
        view.backgroundColor = .white
        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(playerView)
        playerView.snp.makeConstraints { make in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).offset(24)
            make.bottom.right.equalTo(self.view.safeAreaLayoutGuide).offset(-24)
        }
    }
}
