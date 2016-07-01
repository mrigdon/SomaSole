//
//  CreateLoginViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/11/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import TextFieldEffects

extension UITextField {
    var isRed: Bool { return self.layer.borderWidth == 1.5 }
    
    func redBorder(red: Bool) {
        if red {
            self.layer.borderWidth = 1.5
            self.layer.cornerRadius = 5.0
            self.layer.borderColor = UIColor.redColor().CGColor
        }
        else {
            self.layer.borderWidth = 0.0
        }
    }
}

class CreateLoginViewController: UIViewController, UITextFieldDelegate {
    
    var alertController: UIAlertController?

    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var emailField: KaedeTextField!
    @IBOutlet weak var passwordField: KaedeTextField!
    @IBOutlet weak var verifyPasswordField: KaedeTextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    func anyFieldsEmpty() -> Bool {
        return emailField.text?.characters.count == 0 || passwordField.text?.characters.count == 0 || verifyPasswordField.text?.characters.count == 0
    }
    
    func passwordsMatch() -> Bool {
        return passwordField.text == verifyPasswordField.text
    }
    
    func errorAlert(message: String) {
        alertController!.message = message
        presentViewController(alertController!, animated: true, completion: nil)
    }
    
    @IBAction func textFieldChanged(sender: AnyObject) {
        nextButton.enabled = emailField.text != "" && passwordField.text != "" && verifyPasswordField.text != ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // disable next button
        nextButton.enabled = false
        
        // init alert controller
        alertController = UIAlertController(title: "Error", message: "Error", preferredStyle: .Alert)
        let okayAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Default, handler: { value in
            self.alertController!.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController!.addAction(okayAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.isRed {
            textField.redBorder(false)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if anyFieldsEmpty() {
            nextButton.enabled = false
        }
        else {
            nextButton.enabled = true
        }
    }

    // MARK: - Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if !passwordsMatch() {
            passwordField.redBorder(true)
            verifyPasswordField.redBorder(true)
            errorAlert("The passwords do not match.")
            
            return false
        }
        
        return true
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        User.sharedModel.email = emailField.text!
        User.sharedModel.password = passwordField.text!
    }

}
