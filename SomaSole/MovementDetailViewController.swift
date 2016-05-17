//
//  MovementDetailViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/16/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import AWSS3

class MovementDetailViewController: UIViewController {
    
    // variables
    var movement: Movement?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = movement!.title
//        self.descriptionLabel.text = movement!.movementDescription
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        // s3 example
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        let downloadFileString = "Armageddon.jpg"
        let downloadingFileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("downloaded-" + downloadFileString)
        let downloadRequest: AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest.bucket = "somasole/workouts"
        downloadRequest.key = downloadFileString
        downloadRequest.downloadingFileURL = downloadingFileURL
        
        transferManager.download(downloadRequest).continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { task -> AnyObject? in
            
            if task.error != nil {
                print("\n\nerror: <\(task.error)>\n\n")
            }
            
            if task.result != nil {
                let data = NSData(contentsOfURL: downloadingFileURL)
                self.imageView.image = UIImage(data: data!)
            }
            
            return nil
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
