//
//  ChangeSettingViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/6/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

extension UITextField {
    var hasError: Bool { return self.layer.borderWidth != 0.0 }
    
    func addError() {
        self.layer.borderColor = UIColor.redColor().CGColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
    }
    
    func removeError() {
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.blackColor().CGColor
    }
}

class ChangeSettingViewController: UIViewController, UINavigationBarDelegate, UITextFieldDelegate {
    
    let EMAIL_SETTING :Int = 0
    let PASSWORD_SETTING :Int = 1
    let PAYMENT_SETTING :Int = 2
    let settings: NSDictionary = [
        0: "Email",
        1: "Password",
        2: "Payment"
    ]
    
    var selectedSetting: Int = 0
    var alertController: UIAlertController?

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var oldField: UITextField!
    @IBOutlet weak var newField: UITextField!
    @IBOutlet weak var verifyField: UITextField!
    
    func errorOnEmpty() -> Bool {
        var error = false
        
        for field in [oldField, newField, verifyField] {
            if field.text == "" {
                error = true
                field.addError()
            }
        }
        
        return error
    }
    
    func errorOnMismatch() -> Bool {
        return newField.text != verifyField.text
    }
    
    func errorAlert(message: String) {
        alertController!.message = message
        presentViewController(alertController!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let setting: String = settings.objectForKey(selectedSetting) as! String
        self.title = "Change " + setting
        self.settingLabel.text = "Change " + setting
        self.oldField.placeholder = "Old " + setting
        self.newField.placeholder = "New " + setting
        self.verifyField.placeholder = "New " + setting + " Again"
        
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
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.hasError {
            textField.removeError()
        }
    }
    
    @IBAction func tappedCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tappedConfirm(sender: AnyObject) {
        // make sure all fields are filled out
        var error = errorOnEmpty()
        if error {
            errorAlert("Please fill out all fields.")
            return
        }
        
        // TODO: make sure old is correct
        
        // make sure new one matches verify one
        error = errorOnMismatch()
        if error {
            errorAlert("New passwords don't match.")
            return
        }
        
        // TODO: set new password if success
        
        // dismiss
        dismissViewControllerAnimated(true, completion: nil)
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
