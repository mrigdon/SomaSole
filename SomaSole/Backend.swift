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

struct Featured {
    var articles = [Article]()
    var videos = [Video]()
    var workout = Workout()
}

class Backend: NSObject {
    
    // MARK: - Singleton
    
    static let shared = Backend()
    
    // MARK: - Private properties
    
    private let baseURL = "https://somasole-backend.herokuapp.com/api/v1/"
    
    // MARK: - Public methods
    
    func getFeatured(completion: (Featured) -> Void) {
        Alamofire.request(.GET, endpoint("featured")).responseJSON { response in
            if let json = response.result.value {
                var featured = Featured()
                featured.articles = (json["articles"] as! [[String : String]]).map { Article(data: $0) }
                featured.workout = Workout(data: json["workout"] as! [String : AnyObject])
                featured.videos = (json["videos"] as! [[String : AnyObject]]).map { Video(data: $0) }
                
                completion(featured)
            } else {
                completion(Featured())
            }
        }
    }
    
    func getWorkouts(completion: ([Workout]) -> Void) {
        let realm = try! Realm()
        
        let workouts = realm.objects(Workout.self)
        
        if workouts.count > 0 {
            completion(workouts.map { $0 })
            getWorkoutsRemote(nil)
        } else {
            getWorkoutsRemote { workouts in
                completion(workouts)
            }
        }
    }
    
    func getVideos(completion: ([Video]) -> Void) {
        Alamofire.request(.GET, endpoint("videos")).responseJSON { response in
            if let json = response.result.value {
                completion((json["videos"] as! [[String : AnyObject]]).map { Video(data: $0) })
            } else {
                completion([Video]())
            }
        }
    }
    
    // MARK: - Private methods
    
    private func endpoint(string: String) -> String {
        return "\(baseURL)\(string).json"
    }
    
    private func getWorkoutsRemote(completion: (([Workout]) -> Void)?) {
        let realm = try! Realm()
        
        Alamofire.request(.GET, endpoint("workouts")).responseJSON { response in
            if let json = response.result.value {
                var workouts = [Workout]()
                for workout in json["workouts"] as! [[String : AnyObject]] {
                    let workout = Workout(data: workout)
                    workouts.append(workout)
                    try! realm.write {
                        realm.add(workout)
                    }
                }
                completion?(workouts)
            } else {
                completion?([Workout]())
            }
        }
    }

}
