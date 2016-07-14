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
    var textImage: UIImage
    var plainImage: UIImage
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
        
        let plainImageString = data["plainImage"]!
        let plainImageData = NSData(base64EncodedString: plainImageString, options: .IgnoreUnknownCharacters)!
        plainImage = UIImage(data: plainImageData)!
        
        let textImageString = data["textImage"]!
        let textImageData = NSData(base64EncodedString: textImageString, options: .IgnoreUnknownCharacters)!
        textImage = UIImage(data: textImageData)!
    }
    
}
