//
//  GoPremiumViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 6/15/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class GoPremiumViewController: UIViewController {

    // outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // actions
    @IBAction func tappedCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "AvenirNext-UltraLight", size: 24)!
        ]
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
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
