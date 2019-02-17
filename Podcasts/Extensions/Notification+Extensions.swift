//
//  Notification+Extensions.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 24/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let downloadProgress = NSNotification.Name("downloadProgress")
    static let downloadComplete = NSNotification.Name("downloadComplete")
}
