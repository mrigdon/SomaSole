//
//  Article.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/27/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class Article: NSObject {

    var author = ""
    var date: NSDate
    var image: UIImage
    var headline = ""
    var body = ""
    
    init(date: String, data: [String:String]) {
        author = data["author"]!
        headline = data["headline"]!
        body = data["body"]!
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .FullStyle
        self.date = formatter.dateFromString(date)!
        
        let imageString = data["imageString"]!
        let imageData = NSData(base64EncodedString: imageString, options: .IgnoreUnknownCharacters)!
        image = UIImage(data: imageData)!
    }
    
}
