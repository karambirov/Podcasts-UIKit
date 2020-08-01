//
//  CMTime+Extensions.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 27/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import AVKit

extension CMTime {

    func toDisplayString() -> String {
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }

        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds % (60 * 60) / 60
        let hours = totalSeconds / 60 / 60
        let timeFormatString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        return timeFormatString
    }
}
