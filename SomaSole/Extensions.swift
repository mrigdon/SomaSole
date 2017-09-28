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
    mutating func addByDate(_ video: Video) {
        var added = false
        
        for (index, item) in self.enumerated() {
            let otherDate = item as Video
            if (video.date as NSDate).laterDate(otherDate.date as Date) == video.date as Date {
                self.insert(video as! Element, at: index)
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
