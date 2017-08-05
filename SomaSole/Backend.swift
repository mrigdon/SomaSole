//
//  Backend.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 7/24/17.
//  Copyright © 2017 SomaSole. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class Backend: NSObject {
    
    // MARK: - Singleton
    
    static let shared = Backend()
    
    // MARK: - Private properties
    
    private let baseURL = "https://somasole-backend.herokuapp.com/api/v1/"
    
    // MARK: - Public methods
    
    func getFeatured(completion: (Featured) -> Void) {
        Alamofire.request(.GET, endpoint("featured")).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .Success:
                if let json = response.result.value {
                    let featured = Featured()
                    
                    self.clearCachedFeatured()
                    
                    (json["articles"] as! [[String : String]]).forEach { featured.articles.append(Article(data: $0)) }
                    (json["videos"] as! [[String : AnyObject]]).forEach { featured.videos.append(Video(data: $0)) }
                    featured.workout = Workout(data: json["workout"] as! [String : AnyObject])
                    
                    self.cacheFeatured(featured)
                    
                    completion(featured)
                } else {
                    completion(self.getCachedFeatured())
                }
            case .Failure:
                completion(self.getCachedFeatured())
            }
        }
    }
    
    func getWorkouts(completion: ([Workout]) -> Void) {
        Alamofire.request(.GET, endpoint("workouts")).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .Success:
                if let json = response.result.value {
                    var workouts = [Workout]()
                    
                    self.clearCachedWorkouts()
                    
                    for workout in json["workouts"] as! [[String : AnyObject]] {
                        let workout = Workout(data: workout)
                        workouts.append(workout)
                        self.cacheWorkout(workout)
                    }
                    
                    completion(workouts)
                } else {
                    completion(self.getCachedWorkouts())
                }
            case .Failure:
                completion(self.getCachedWorkouts())
            }
        }
    }
    
    func getVideos(completion: ([Video]) -> Void) {
        Alamofire.request(.GET, endpoint("videos")).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .Success:
                if let json = response.result.value {
                    var videos = [Video]()
                    
                    self.clearCachedVideos()
                    
                    for video in json["videos"] as! [[String : AnyObject]] {
                        let video = Video(data: video)
                        videos.append(video)
                        self.cacheVideo(video)
                    }
                    
                    completion(videos)
                } else {
                    completion(self.getCachedVideos())
                }
            case .Failure:
                completion(self.getCachedVideos())
            }
        }
    }
    
    // MARK: - Private methods
    
    private func endpoint(string: String) -> String {
        return "\(baseURL)\(string).json"
    }
    
    private func cacheFeatured(featured: Featured) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(featured.articles)
        }
        try! realm.write {
            realm.add(featured.videos)
        }
        try! realm.write {
            realm.add(featured.workout!)
        }
    }
    
    private func getCachedFeatured() -> Featured {
        let realm = try! Realm()
        
        let featured = Featured()
        realm.objects(Article.self).forEach { featured.articles.append($0) }
        realm.objects(Video.self).filter("featured == YES").forEach { featured.videos.append($0) }
        featured.workout = realm.objects(Workout.self).filter("featured == YES").first
        
        return featured ?? Featured()
    }
    
    private func clearCachedFeatured() {
        let realm = try! Realm()
        let articles = realm.objects(Article.self)
        let videos = realm.objects(Video.self).filter("featured == YES")
        let workout = realm.objects(Workout.self).filter("featured == YES").first
        try! realm.write {
            realm.delete(articles)
        }
        try! realm.write {
            realm.delete(videos)
        }
        if let workout = workout {
            try! realm.write {
                realm.delete(workout)
            }
        }
    }
    
    private func cacheWorkout(workout: Workout) {
        if !workout.featured {
            let realm = try! Realm()
            try! realm.write {
                realm.add(workout)
            }
        }
    }
    
    private func getCachedWorkouts() -> [Workout] {
        let realm = try! Realm()
        let workouts = realm.objects(Workout.self)
        
        return workouts.map { $0 }
    }
    
    private func clearCachedWorkouts() {
        let realm = try! Realm()
        let workouts = realm.objects(Workout.self).filter("featured == NO")
        try! realm.write {
            realm.delete(workouts)
        }
    }
    
    private func cacheVideo(video: Video) {
        if !video.featured {
            let realm = try! Realm()
            try! realm.write {
                realm.add(video)
            }
        }
    }
    
    private func getCachedVideos() -> [Video] {
        let realm = try! Realm()
        let videos = realm.objects(Video.self)
        
        return videos.map { $0 }
    }
    
    private func clearCachedVideos() {
        let realm = try! Realm()
        let videos = realm.objects(Video.self).filter("featured == NO")
        try! realm.write {
            realm.delete(videos)
        }
    }

}
