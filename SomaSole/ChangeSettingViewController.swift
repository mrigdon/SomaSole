//
//  ChangeSettingViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/6/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

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

enum Setting: Int {
    case Email, Password, Payment
}

class ChangeSettingViewController: UIViewController, UITextFieldDelegate {
    
    var firebase: Firebase?
    let user = User.sharedModel
    
    let settings: NSDictionary = [
        0: "Email",
        1: "Password",
        2: "Payment"
    ]
    
    var selectedSetting: Setting = .Email
    var alertController: UIAlertController?
    var alertControllerShouldDismiss: Bool = false
    var newEmail: String?
    var newPassword: String?

    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var oldField: UITextField!
    @IBOutlet weak var newField: UITextField!
    @IBOutlet weak var verifyField: UITextField!
    
    func startProgressHud() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    func stopProgressHud() {
        dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
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
        alertControllerShouldDismiss = false
        alertController?.title = "Error"
        alertController!.message = message
        presentViewController(alertController!, animated: true, completion: nil)
    }
    
    func successAlert(message: String) {
        alertControllerShouldDismiss = true
        alertController?.title = "Success!"
        alertController!.message = message
        presentViewController(alertController!, animated: true, completion: nil)
    }
    
    func saveUserData(field: Setting) {
        let user = User.sharedModel
        
        if field == .Email {
            user.email = newEmail
            firebase?.childByAppendingPath("users").childByAppendingPath("email").setValue(newEmail)
            NSUserDefaults.standardUserDefaults().setObject(User.data(), forKey: "userData")
            self.stopProgressHud()
            self.successAlert("Successfully changed email to \(newEmail)")
        }
            
        else if field == .Password {
            user.password = newPassword
            NSUserDefaults.standardUserDefaults().setObject(User.data(), forKey: "userData")
            self.stopProgressHud()
            self.successAlert("Successfully changed password to \(newPassword)")
        }
    }
    
    func changeField(field: Setting) {
        // email
        if field == .Email {
            newEmail = newField.text
            firebase?.changeEmailForUser(user.email, password: user.password, toNewEmail: newEmail, withCompletionBlock: { error in
                // success
                if error == nil {
                    // save to firebase
                    self.saveUserData(.Email)
                }
                    // error
                else {
                    self.stopProgressHud()
                    print(error)
                    switch error.code {
                        case FAuthenticationError.InvalidEmail.rawValue:
                            self.errorAlert("Incorrect email.")
                            break
                        case FAuthenticationError.InvalidPassword.rawValue:
                            self.errorAlert("Incorrect password.")
                            break
                        case FAuthenticationError.NetworkError.rawValue:
                            self.errorAlert("The network is unavailable, please try again later.")
                            break
                        default:
                            break
                        }
                }
            })
        }
        
        // password
        else if field == .Password {
            newPassword = newField.text
            firebase?.changePasswordForUser(user.email, fromOld: user.password, toNew: newPassword, withCompletionBlock: { error in
                // success
                if error == nil {
                    // save to firebase
                    self.saveUserData(.Password)
                }
                // error
                else {
                    self.stopProgressHud()
                    switch error.code {
                        case FAuthenticationError.InvalidEmail.rawValue:
                            self.errorAlert("Incorrect email.")
                            break
                        case FAuthenticationError.InvalidPassword.rawValue:
                            self.errorAlert("Incorrect password.")
                            break
                        case FAuthenticationError.NetworkError.rawValue:
                            self.errorAlert("The network is unavailable, please try again later.")
                            break
                        default:
                            break
                    }
                }
            })
        }
    }
    
    func resignAndDismiss() {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let setting: String = settings.objectForKey(selectedSetting.rawValue) as! String
        self.title = "Change " + setting
        self.settingLabel.text = "Change " + setting
        self.oldField.placeholder = "Old " + setting
        self.newField.placeholder = "New " + setting
        self.verifyField.placeholder = "New " + setting + " Again"
        
        // white back button
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
        // secure text entry if password
        self.oldField.secureTextEntry = selectedSetting == .Password
        self.newField.secureTextEntry = selectedSetting == .Password
        self.verifyField.secureTextEntry = selectedSetting == .Password
        
        // init alert controller
        alertController = UIAlertController(title: "Error", message: "Error", preferredStyle: .Alert)
        let okayAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Default, handler: { value in
            self.alertController!.dismissViewControllerAnimated(true, completion: nil)
            if self.alertControllerShouldDismiss {
                self.resignAndDismiss()
            }
        })
        alertController!.addAction(okayAction)
        
        // init firebase
        firebase = Firebase(url: "http://somasole.firebaseio.com")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.hasError {
            textField.removeError()
        }
    }
    
    @IBAction func tappedCancel(sender: AnyObject) {
        resignAndDismiss()
    }
    
    @IBAction func tappedConfirm(sender: AnyObject) {
        // make sure all fields are filled out
        if errorOnEmpty() {
            errorAlert("Please fill out all fields.")
            return
        }
        
        // make sure new one matches verify one
        if errorOnMismatch() {
            errorAlert("New \(settings.objectForKey(selectedSetting.hashValue)!.lowercaseString!)s don't match.")
            return
        }
        
        startProgressHud()
        
        // change field
        changeField(selectedSetting)
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
