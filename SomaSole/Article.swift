//
//  Article.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/27/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class Article: NSObject {
    
    let textImageDimensions: Int64 = 1 * 1400 * 900
    let plainImageDimensions: Int64 = 1 * 1400 * 1400

    var author = ""
    var date: NSDate
    var textImage = UIImage()
    var plainImage = UIImage()
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
    }
    
    func loadImages(completion: () -> Void) {
        let file = headline + ".jpg"
        
        // first load text
        let textImageRef = FirebaseManager.sharedStorage.child("articles/text").child(file)
        textImageRef.dataWithMaxSize(textImageDimensions, completion: { data, error in
            if error != nil {
                // TODO: handle error
                print(error)
            } else if let data = data {
                if let image = UIImage(data: data) {
                    self.textImage = image
                    completion()
                }
            }
        })
        
        // then load plain
        let plainImageRef = FirebaseManager.sharedStorage.child("articles/plain").child(file)
        plainImageRef.dataWithMaxSize(plainImageDimensions, completion: { data, error in
            if error != nil {
                // TODO: handle error
                print(error)
            } else if let data = data {
                if let image = UIImage(data: data) {
                    self.plainImage = image
                }
            }
        })
    }
    
    func loadTextImage(completion: () -> Void) {
        let file = headline + ".jpg"
        let imageRef = FirebaseManager.sharedStorage.child("articles/text").child(file)
        imageRef.dataWithMaxSize(textImageDimensions, completion: { data, error in
            if error != nil {
                // TODO: handle error
                print(error)
            } else if let data = data {
                if let image = UIImage(data: data) {
                    self.textImage = image
                    completion()
                }
            }
        })
    }
    
    func loadPlainImage(completion: () -> Void) {
        let file = headline + ".jpg"
        let imageRef = FirebaseManager.sharedStorage.child("articles/plain").child(file)
        imageRef.dataWithMaxSize(plainImageDimensions, completion: { data, error in
            if error != nil {
                // TODO: handle error
                print(error)
            } else if let data = data {
                if let image = UIImage(data: data) {
                    self.plainImage = image
                    completion()
                }
            }
        })
    }
    
}
