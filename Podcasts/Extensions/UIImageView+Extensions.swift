//
//  UIImageView+Extensions.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 12/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Kingfisher
import UIKit

extension UIImageView {

    func setImage(from url: URL?) {
        guard let url = url else {
            preconditionFailure("Failed to load image URL.")
        }
        kf.setImage(with: url)
    }

    func setImage(from url: URL?, completionHandler: ((UIImage) -> Void)? = nil) {
        guard let url = url else {
            preconditionFailure("Failed to load image URL.")
        }
        kf.setImage(with: url) { result in
            switch result {
            case let .success(retrieveImageResult):
                completionHandler?(retrieveImageResult.image)
            case let .failure(error):
                assertionFailure(error.errorDescription ?? "")
            }
        }
    }
}
