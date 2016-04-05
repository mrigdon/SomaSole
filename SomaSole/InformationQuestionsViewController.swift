//
//  InformationQuestionsViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/5/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

class InformationQuestionsViewController: UIViewController {

    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var textView3: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // add borders to text fields
        textView1.layer.borderColor = UIColor.blackColor().CGColor
        textView1.layer.borderWidth = 1.0
        textView2.layer.borderColor = UIColor.blackColor().CGColor
        textView2.layer.borderWidth = 1.0
        textView3.layer.borderColor = UIColor.blackColor().CGColor
        textView3.layer.borderWidth = 1.0
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
