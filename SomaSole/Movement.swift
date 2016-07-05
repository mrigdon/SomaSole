//
//  Movement.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/19/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import AWSS3
import RealmSwift

class Movement: NSObject {
    
    static var sharedMovements = [Movement]()
    
    var title: String = ""
    var index: Int
    var image: UIImage?
    var gif: NSData?
    var time: Int?
    var movementDescription: String?
    var finished = false
    
    init(index: Int, time: Int) {
        self.index = index
        self.time = time
    }
    
    init(index: Int, data: [String:String]) {
        self.index = index
        self.title = data["title"]!
        self.movementDescription = data["description"]!
    }
    
    func decodeImage(imageString: String) {
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
    
    func addGifToRealm() {
        
    }
    
    func loadGif(completion: () -> Void) {
        // first try from realm
        let realm = try! Realm()
        let realmGif = realm.objects(ROGif).filter("title = '\(self.title)'")
        
        // get from s3 if not in realm, then add to realm
        if realmGif.count != 0 {
            self.gif = realmGif[0].data
            completion()
        } else {
            let transferManager = AWSS3TransferManager.defaultS3TransferManager()
            let downloadFileString = self.title + ".gif"
            let downloadingFileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("downloaded-" + downloadFileString)
            let downloadRequest: AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
            downloadRequest.bucket = "somasole/movements/gif"
            downloadRequest.key = downloadFileString
            downloadRequest.downloadingFileURL = downloadingFileURL
            
            transferManager.download(downloadRequest).continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { task -> AnyObject? in
                
                if task.result != nil {
                    self.gif = NSData(contentsOfURL: downloadingFileURL)
                    completion()
                    
                    // cache to realm
                    let rGif = ROGif()
                    rGif.title = self.title
                    rGif.data = self.gif!
                    try! realm.write {
                        realm.add(rGif)
                    }
                }
                
                return nil
            })
        }
    }
    
}
