//
//  Extensions.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 9/12/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIView {
    func clearSubviews() {
        for v in subviews {
            v.removeFromSuperview()
        }
    }
}

extension Array where Element: Workout {
    mutating func insertAlpha(_ workout: Element) {
        if self.count == 0 {
            self.append(workout)
            return
        }
        
        for (index, item) in self.enumerated() {
            if workout.name.localizedCompare(item.name) == .orderedAscending {
                self.insert(workout, at: index)
                return
            }
        }
        
        self.append(workout)
    }
    
    var names: [String] {
        var favoriteWorkouts = [String]()
        for workout in Workout.sharedFavorites {
            favoriteWorkouts.append(workout.name)
        }
        return favoriteWorkouts
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

extension DateFormatter {
    static let somasoleDateFormat = "MMM dd yyyy, h:mm a"
}

extension UIViewController {
    func startProgressHud() {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func stopProgressHud() {
        DispatchQueue.main.async(execute: {
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
}
