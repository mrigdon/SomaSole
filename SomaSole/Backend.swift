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
    
    fileprivate let baseURL = "https://somasole-backend.herokuapp.com/api/v1/"
    
    // MARK: - Public methods
    
    func getFeatured(_ completion: @escaping (Featured) -> Void) {
        Alamofire.request(endpoint("featured")).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String : AnyObject] {
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
            case .failure:
                completion(self.getCachedFeatured())
                print("TODO")
            }
        }
    }
    
    func getWorkouts(_ completion: @escaping ([Workout]) -> Void) {
        Alamofire.request(endpoint("workouts")).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String : AnyObject] {
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
            case .failure:
                completion(self.getCachedWorkouts())
                print("todo")
            }
        }
    }
    
    func getVideos(_ completion: @escaping ([Video]) -> Void) {
        Alamofire.request(endpoint("videos")).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String : AnyObject] {
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
            case .failure:
                completion(self.getCachedVideos())
                print("todo")
            }
        }
    }
    
    // MARK: - Private methods
    
    fileprivate func endpoint(_ string: String) -> String {
        return "\(baseURL)\(string).json"
    }
    
    fileprivate func cacheFeatured(_ featured: Featured) {
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
        
        return featured
    }
    
    fileprivate func clearCachedFeatured() {
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
    
    fileprivate func cacheWorkout(_ workout: Workout) {
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
    
    fileprivate func clearCachedWorkouts() {
        let realm = try! Realm()
        let workouts = realm.objects(Workout.self).filter("featured == NO")
        try! realm.write {
            realm.delete(workouts)
        }
    }
    
    fileprivate func cacheVideo(_ video: Video) {
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
    
    fileprivate func clearCachedVideos() {
        let realm = try! Realm()
        let videos = realm.objects(Video.self).filter("featured == NO")
        try! realm.write {
            realm.delete(videos)
        }
    }

}
