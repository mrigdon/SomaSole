//
//  Movement.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/19/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import AWSS3

class Movement: NSObject {
    
    static var sharedMovements = [Movement]()
    
    var title: String
    var index: Int?
    var image: UIImage?
    var gif: NSData?
    var time: Int?
    var movementDescription: String?
    var finished = false
    
    init(title: String, time: Int) {
        self.title = title
        self.time = time
    }
    
    init(index: Int, data: [String:String]) {
        self.index = index
        self.title = data["title"]!
        self.movementDescription = data["description"]!
        
        let imageString = data["jpg"]!
        let decodedData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        image = UIImage(data: decodedData!)
    }
    
    func loadImage(completion: () -> Void) {
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        let downloadFileString = self.title + ".jpg"
        let downloadingFileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("downloaded-" + downloadFileString)
        let downloadRequest: AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest.bucket = "somasole/movements/jpg"
        downloadRequest.key = downloadFileString
        downloadRequest.downloadingFileURL = downloadingFileURL
        
        transferManager.download(downloadRequest).continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { task -> AnyObject? in
            
            if task.result != nil {
                let data = NSData(contentsOfURL: downloadingFileURL)
                self.image =  UIImage(data: data!)!
                completion()
            }
            
            return nil
        })
    }
    
}
