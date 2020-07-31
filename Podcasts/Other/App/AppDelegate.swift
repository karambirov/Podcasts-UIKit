//
//  AppDelegate.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 21/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator
import Gedatsu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.makeKeyAndVisible()

        let mainTabBarViewModel = MainTabBarViewModel(items: [.search, .favorites, .downloads])
        window?.rootViewController = MainTabBarController(viewModel: mainTabBarViewModel)
        window?.tintColor = R.color.tintColor()

        NetworkActivityIndicatorManager.shared.isEnabled = true

		#if DEBUG
		Gedatsu.open()
		#endif

        return true
    }

}
