//
//  MiniPlayerView.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 18/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import UIKit
import SnapKit

final class MiniPlayerView: UIView {

    // MARK: - Properties
    fileprivate lazy var separatorView     = UIView()
    fileprivate lazy var imageView         = UIImageView()
    fileprivate lazy var titleLabel        = UILabel()
    fileprivate lazy var playPauseButton   = UIButton(type: .system)
    fileprivate lazy var fastForwardButton = UIButton(type: .system)
    fileprivate lazy var stackView         = UIStackView(arrangedSubviews: [imageView, titleLabel, playPauseButton, fastForwardButton])

    // MARK: - Life cycle
    override func didMoveToSuperview() {
        setupViews()
    }

    // TODO: - Configure init to set label text and actions for buttons

}

// MARK: - Setup
extension MiniPlayerView {

    fileprivate func setupViews() {
        setupImageView()
        setupTitleLabel()
        setupPlayPauseButton()
        setupFastForwardButton()
        setupStackView()
        setupLayout()
    }

    private func setupLayout() {
        self.addSubview(separatorView)
        self.addSubview(stackView)

        separatorView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(0.5)
        }

        stackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().offset(8)
            make.top.equalTo(separatorView).offset(8)
        }

        self.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(64)
        }
    }

    private func setupImageView() {
        imageView.image       = R.image.appicon()
        imageView.contentMode = .scaleAspectFill
        imageView.snp.makeConstraints { $0.width.equalTo(48) }
    }

    private func setupTitleLabel() {
        titleLabel.text      = "Episode Title"
        titleLabel.font      = .systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .darkText
    }

    private func setupPlayPauseButton() {
        playPauseButton.setTitle("", for: .normal)
        playPauseButton.setImage(R.image.pause(), for: .normal)
        playPauseButton.snp.makeConstraints { $0.width.equalTo(48) }
    }

    private func setupFastForwardButton() {
        fastForwardButton.setTitle("", for: .normal)
        fastForwardButton.setImage(R.image.fastforward15(), for: .normal)
        fastForwardButton.snp.makeConstraints { $0.width.equalTo(48) }
    }

    private func setupStackView() {
        stackView.addArrangedSubview(imageView)

    }

}
