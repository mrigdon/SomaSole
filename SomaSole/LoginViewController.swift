//
//  LoginViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/7/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let placeholderColor = UIColor(red: 0.7803921569, green: 0.7803921569, blue: 0.8039215686, alpha: 1.0)
    
    var alertController: UIAlertController?
    let firebaseURL = "https://somasole.firebaseio.com"
    var firebase: Firebase?
    var email: String?
    var password: String?

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var fbLoginButton: FBSDKButton!
    
    func stopProgressHud() {
        dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    func errorAlert(message: String) {
        alertController!.message = message
        presentViewController(alertController!, animated: true, completion: nil)
    }
    
    func anyFieldsEmpty() -> Bool {
        return emailField.text?.characters.count == 0 || passField.text?.characters.count == 0
    }
    
    func getUserDataAndLogin(uid: String) {
        firebase?.childByAppendingPath("users").childByAppendingPath(uid).observeEventType(.Value, withBlock: { snapshot in
            // populate shared model with data
            var userData: Dictionary<String, AnyObject> = snapshot.value as! Dictionary<String, AnyObject>
            userData["password"] = self.password
            User.populateFields(userData)
            
            // save to user defaults
            NSUserDefaults.standardUserDefaults().setObject(userData["uid"], forKey: "uid")
            NSUserDefaults.standardUserDefaults().setObject(userData, forKey: "userData")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            // stop progress hud
            self.stopProgressHud()
            
            // login
            self.performSegueWithIdentifier("toMain", sender: self)
        })
    }
    
    @objc private func tappedFacebook() {
        let loginManager = FBSDKLoginManager()
        let permissions = ["public_profile", "email"]
        loginManager.logInWithReadPermissions(permissions, fromViewController: self, handler: { fbResult, fbError in
            if fbError != nil {
                print("fbError: \(fbError.code)")
            }
            else if fbResult.isCancelled {
                print("cancelled facebook login")
            }
            else {
                print("logged in")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        firebase = Firebase(url: firebaseURL)
        
        // customize text fields
        emailField.layer.borderColor = placeholderColor.CGColor
        emailField.layer.borderWidth = 1.0
        emailField.layer.cornerRadius = 5.0
        passField.layer.borderColor = placeholderColor.CGColor
        passField.layer.borderWidth = 1.0
        passField.layer.cornerRadius = 5.0
        
        // init alert controller
        alertController = UIAlertController(title: "Error", message: "Error", preferredStyle: .Alert)
        let okayAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Default, handler: { value in
            self.alertController!.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController!.addAction(okayAction)
        
        // init fb login
        fbLoginButton.addTarget(self, action: #selector(LoginViewController.tappedFacebook), forControlEvents: .TouchUpInside)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        emailField.resignFirstResponder()
        passField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginUser() {
        firebase?.authUser(email, password: password, withCompletionBlock: { error, authData in
            // if error
            if error != nil {
                print(error)
                switch error.code {
                    case FAuthenticationError.UserDoesNotExist.rawValue:
                        self.stopProgressHud()
                        self.errorAlert("There is no account with the given email.")
                    case FAuthenticationError.InvalidEmail.rawValue:
                        self.stopProgressHud()
                        self.errorAlert("There is no account with the given email.")
                    case FAuthenticationError.InvalidPassword.rawValue:
                        self.stopProgressHud()
                        self.errorAlert("Incorrect password.")
                    case FAuthenticationError.NetworkError.rawValue:
                        self.stopProgressHud()
                        self.errorAlert("The network is currently unavailable, please try again in a few moments.")
                default:
                    break
                }
            }
            // success
            else {
                // get user and login
                self.getUserDataAndLogin(authData.uid)
            }
        })
    }
    
    @IBAction func tappedLogin(sender: AnyObject) {
        // return if any fields are empty
        if anyFieldsEmpty() {
            errorAlert("Please fill out all fields.")
            return
        }
        
        // start progress hud
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        // get username and password
        email = emailField.text
        password = passField.text
        
        loginUser()
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using segue.destinationViewController.
//        let main: ProfileViewController = segue.destinationViewController as! ProfileViewController
        
        // Pass the selected object to the new view controller.
    }

}
