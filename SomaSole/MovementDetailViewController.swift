//
//  MovementDetailViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/16/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import AWSS3
import Gifu
import MBProgressHUD

class MovementDetailViewController: UIViewController {
    
    // constants
    let descriptionFont = UIFont(name: "Helvetica Neue", size: 17.0)
    
    // variables
    var movement: Movement?
    var url = NSURL()
    var data = NSData()

    // outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: AnimatableImageView!
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
    
    func loadGif() {
        // if not nil
        if let gif = self.movement!.gif {
            self.imageView.animateWithImageData(gif)
            self.stopProgressHud()
            return
        }
        
        // fetch first time
        movement!.loadGif({
            self.imageView.animateWithImageData(self.movement!.gif!)
            self.stopProgressHud()
        })
    }
    
    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = movement!.title
        self.descriptionLabel.text = movement!.movementDescription
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
        ui {
            self.imageView.animateWithImageData(self.data)
        }
        stopProgressHud()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        imageView.stopAnimatingGIF()
        super.viewWillDisappear(animated)
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
