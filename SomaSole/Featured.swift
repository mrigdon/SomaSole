//
//  Featured.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 8/5/17.
//  Copyright © 2017 SomaSole. All rights reserved.
//

import Foundation
//import RealmSwift

//class Featured: Object {
class Featured: NSObject {

//    var articles = List<Article>()
    var articles = [Article]()
//    var videos = List<Video>()
    var videos = [Video]()
    @objc dynamic var workout: Workout?
    
}
