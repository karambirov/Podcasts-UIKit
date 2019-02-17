//
//  UIApplication+Extensions.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 21/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit

extension UIApplication {

    static var mainTabBarController: MainTabBarController? {
        return shared.keyWindow?.rootViewController as? MainTabBarController
    }

}
