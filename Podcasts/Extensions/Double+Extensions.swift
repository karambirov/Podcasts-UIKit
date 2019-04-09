//
//  Double+Extensions.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 09/04/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Foundation

extension Double {

    func toDisplayString() -> String {
        let totalSeconds = Int(self)
        let seconds = totalSeconds % 60
        let minutes = totalSeconds % (60 * 60) / 60
        let hours = totalSeconds / 60 / 60
        let timeFormatString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        return timeFormatString
    }

}
