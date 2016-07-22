//
//  TermsViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 7/21/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {
    
    var acceptClosure = {}

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var acceptLabel: UILabel!
    
    @IBAction func tappedCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tappedAccept(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: {
            self.acceptClosure()
        })
    }
    
    @IBAction func tappedSwitch(sender: AnyObject) {
        acceptButton.enabled = `switch`.on
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        acceptButton.enabled = false
        acceptLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func viewDidAppear(animated: Bool) {
        textView.setContentOffset(CGPointZero, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
