//
//  MovementDetailViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/16/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import MBProgressHUD
import FLAnimatedImage

class MovementDetailViewController: UIViewController {
    
    // constants
    let descriptionFont = UIFont(name: "Helvetica Neue", size: 17.0)
    
    // variables
    var movement: Movement?
    var url = NSURL()
    var data = NSData()
    var image = FLAnimatedImage()

    // outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: FLAnimatedImageView!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    // methods
    func startProgressHud() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    func stopProgressHud() {
        dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    private func ui(closure: () -> Void) {
        dispatch_async(dispatch_get_main_queue(), {
            closure()
        })
    }
    
    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = movement!.title
        self.descriptionLabel.text = movement!.deskription
        self.descriptionLabel.editable = true
        self.descriptionLabel.font = descriptionFont
        self.descriptionLabel.textAlignment = .Center
        self.descriptionLabel.editable = false
        navigationController!.navigationBar.tintColor = UIColor.blackColor()
        startProgressHud()
    }
    
    override func viewDidAppear(animated: Bool) {
        url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("\(movement!.title).gif", ofType: nil)!)
        data = NSData(contentsOfURL: self.url)!
        image = FLAnimatedImage(animatedGIFData: data)
        ui {
            self.imageView.animatedImage = self.image
        }
        stopProgressHud()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        imageView.stopAnimating()
        super.viewWillDisappear(animated)
    }

}
