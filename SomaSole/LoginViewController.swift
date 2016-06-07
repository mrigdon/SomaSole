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
import TextFieldEffects

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // constants
    let placeholderColor = UIColor(red: 0.7803921569, green: 0.7803921569, blue: 0.8039215686, alpha: 1.0)
    
    // variables
    var alertController: UIAlertController?
    var email: String?
    var password: String?

    // outlets
    @IBOutlet weak var emailField: KaedeTextField!
    @IBOutlet weak var passField: KaedeTextField!
    @IBOutlet weak var fbLoginButton: FBSDKButton!
    @IBOutlet weak var logoImageView: UIImageView!
    
    // methods
    private func stopProgressHud() {
        dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    func startProgressHud() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    private func errorAlert(message: String) {
        alertController!.message = message
        presentViewController(alertController!, animated: true, completion: nil)
    }
    
    private func anyFieldsEmpty() -> Bool {
        return emailField.text?.characters.count == 0 || passField.text?.characters.count == 0
    }
    
    private func createUserFromFacebook(userData: [String:AnyObject]) {
        User.sharedModel.email = userData["email"] as? String
        User.sharedModel.firstName = userData["first_name"] as? String
        User.sharedModel.lastName = userData["last_name"] as? String
        User.sharedModel.male = userData["gender"] as? String == "male"
        
        let urlString = ((userData["picture"] as! [String:AnyObject])["data"] as! [String:AnyObject])["url"] as! String
        let url = NSURL(string: urlString)
        let data = NSData(contentsOfURL: url!)
        let image = UIImage(data: data!)
        User.sharedModel.profileImage = image
        
        stopProgressHud()
        performSegueWithIdentifier("facebookCreateSegue", sender: self)
    }
    
    private func getUserDataAndLogin(uid: String) {
        FirebaseManager.sharedRootRef.childByAppendingPath("users").childByAppendingPath(uid).observeEventType(.Value, withBlock: { snapshot in
            if !(snapshot.value is NSNull) {
                // user exsits
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
            }
            else {
                // user does not exist
                let fields = ["fields": "email,first_name,last_name,birthday,gender,picture.type(large)"]
                let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: fields)
                graphRequest.startWithCompletionHandler({ connection, result, error in
                    if error == nil {
                        // success
                        User.sharedModel.uid = uid
                        let userData = result as! [String:AnyObject]
                        self.createUserFromFacebook(userData)
                    }
                    else {
                        // error
                        print(error)
                    }
                })
            }
        })
    }
    
    private func loginUser() {
        FirebaseManager.sharedRootRef.authUser(email, password: password, withCompletionBlock: { error, authData in
            if error != nil {
                self.handleFirebaseError(error)
            }
            else {
                self.getUserDataAndLogin(authData.uid)
            }
        })
    }
    
    private func handleFirebaseError(error: NSError) {
        switch error.code {
            
        case FAuthenticationError.EmailTaken.rawValue:
            self.errorAlert("There is already an account with this email.")
            break
        case FAuthenticationError.NetworkError.rawValue:
            self.errorAlert("There is a problem with the network, please try again in a few moments.")
            break
        case FAuthenticationError.InvalidEmail.rawValue:
            self.errorAlert("The email you entered is invalid.")
            break
        case FAuthenticationError.UserDoesNotExist.rawValue:
            self.errorAlert("There is no registered account with that email.")
            break
        case FAuthenticationError.InvalidPassword.rawValue:
            self.errorAlert("The password you entered is incorrect.")
            break
        default:
            break
            
        }
    }
    
    // actions
    @IBAction func tappedFacebookLogin(sender: AnyObject) {
        User.sharedModel.facebookUser = true
        let loginManager = FBSDKLoginManager()
        let permissions = ["public_profile", "email"]
        loginManager.logInWithReadPermissions(permissions, fromViewController: self, handler: { fbResult, fbError in
            if fbError != nil {
                // error in login
                print("fbError: \(fbError.code)")
            }
            else if fbResult.isCancelled {
                // cancelled login
                print("cancelled facebook login")
            }
            else {
                // fb logged in
                self.startProgressHud()
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                FirebaseManager.sharedRootRef.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                    if error != nil {
                        self.handleFirebaseError(error)
                    }
                    else {
                        // firebase logged in
                        self.getUserDataAndLogin(authData.uid)
                    }
                })
            }
        })
    }
    
    @IBAction func tappedLogin(sender: AnyObject) {
        User.sharedModel.facebookUser = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        emailField.resignFirstResponder()
        passField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "facebookCreateSegue" {
            let createBasicsVC = (segue.destinationViewController as! UINavigationController).viewControllers.first as! CreateBasicsViewController
            createBasicsVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: createBasicsVC, action: #selector(CreateBasicsViewController.dismiss))
        }
    }

}
