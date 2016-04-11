//
//  LoginViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/7/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let EMAIL_TAKEN = -9
    let placeholderColor = UIColor(red: 0.7803921569, green: 0.7803921569, blue: 0.8039215686, alpha: 1.0)
    
    var firebase: Firebase?
    var email: String?
    var password: String?

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var createEmailField: UITextField!
    @IBOutlet weak var createPassField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        firebase = Firebase(url: "https://somasole.firebaseio.com")
        
        // customize text fields
        emailField.layer.borderColor = placeholderColor.CGColor
        emailField.layer.borderWidth = 1.0
        emailField.layer.cornerRadius = 5.0
        passField.layer.borderColor = placeholderColor.CGColor
        passField.layer.borderWidth = 1.0
        passField.layer.cornerRadius = 5.0
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
            if error != nil {
                print("Error in trying to login user: \(error)")
            }
            else {
                print(authData.providerData)
                // save user to database
//                let newUser = [
//                    "provider": authData.provider,
//                    "displayName": authData.providerData["displayName"] as! String
//                ]
                
                // save info to user defaults
                NSUserDefaults.standardUserDefaults().setObject(self.email, forKey: "email")
                NSUserDefaults.standardUserDefaults().setObject(self.password, forKey: "password")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                self.performSegueWithIdentifier("toMain", sender: self)
            }
        })
    }
    
    @IBAction func tappedLogin(sender: AnyObject) {
        // get username and password
        email = emailField.text
        password = passField.text
        
        // return if either is empty
        if email == "" || password == "" {
            return
        }
        
        loginUser()
    }
    
    @IBAction func tappedCreateAccount(sender: AnyObject) {
        // get username and password
        email = createEmailField.text
        password = createPassField.text
        
        // return if either is empty
        if email == "" || password == "" {
            return
        }
        
        // create firebase user
        firebase!.createUser(email, password: password, withValueCompletionBlock: { error, result in
            if error != nil {
                if error.code == self.EMAIL_TAKEN {
                    // handle email taken
                }
            }
            else {
                // login user
                self.loginUser()
            }
        })
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using segue.destinationViewController.
//        let main: ProfileViewController = segue.destinationViewController as! ProfileViewController
        
        // Pass the selected object to the new view controller.
    }

}
