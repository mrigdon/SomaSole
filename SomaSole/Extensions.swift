//
//  Extensions.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 9/12/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

extension UIView {
    func clearSubviews() {
        for v in subviews {
            v.removeFromSuperview()
        }
    }
}

extension Array where Element: Video {
    mutating func addByDate(video: Video) {
        var added = false
        
        for (index, item) in self.enumerate() {
            let otherDate = item as Video
            if video.date.laterDate(otherDate.date) == video.date {
                self.insert(video as! Element, atIndex: index)
                added = true
                break
            }
        }
        
        if !added {
           append(video as! Element)
        }
    }
}

extension Int {
    var workoutTag: WorkoutTag {
        return WorkoutTag(rawValue: self)!
    }
}
