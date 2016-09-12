//
//  Video.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 6/4/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class Video: NSObject {
    
    static var sharedFavorites = [Video]()

    var id = ""
    var title = ""
    var time = 0
    var videoDescription = ""
    var favorite = false
    var free = false
    var image: UIImage?
    
    init(id: String, data: [String:AnyObject]) {
        super.init()
        self.id = id
        self.title = data["title"] as! String
        self.time = data["time"] as! Int
        self.videoDescription = data["description"] as! String
    }
    
    func loadImage(completion: () -> Void) {
        Alamofire.request(.GET, "http://img.youtube.com/vi/\(id)/mqdefault.jpg").responseImage(completionHandler: { response in
            if let image = response.result.value {
                self.image = image
                completion()
            }
        })
    }
}
