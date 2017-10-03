//
//  Featured.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 8/5/17.
//  Copyright © 2017 SomaSole. All rights reserved.
//

import Foundation
import RealmSwift

class Featured: Object {

    var articles = List<Article>()
    var videos = List<Video>()
    @objc dynamic var workout: Workout?
    
}
