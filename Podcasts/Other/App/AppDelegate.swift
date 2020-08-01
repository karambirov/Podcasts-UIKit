//
//  AppDelegate.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 21/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import AlamofireNetworkActivityIndicator
import Gedatsu
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow()
        window?.makeKeyAndVisible()

        let mainTabBarViewModel = MainTabBarViewModel(items: [.search, .favorites, .downloads])
        window?.rootViewController = MainTabBarController(viewModel: mainTabBarViewModel)
        window?.tintColor = AppConfig.tintColor

        NetworkActivityIndicatorManager.shared.isEnabled = true

        #if DEBUG
        Gedatsu.open()
        #endif

        return true
    }
}
