//
//  ChangePasswordViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 6/25/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

extension UIColor {
    static func placeholderGray() -> UIColor {
        return UIColor(red: 0.666666686534882, green: 0.666666686534882, blue: 0.666666686534882, alpha: 1.0)
    }
}

class ChangePasswordViewController: UITableViewController {
    
    // constants
    let passwordPlaceholders = ["Current Password", "New Password", "New Password (Again)"]
    let emailPlaceholders = ["Current Email", "New Email", "Enter Password"]
    
    // variables
    var textFields = [UITextField]()
    var alertController: UIAlertController?
    var email = true
    
    // outlets
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // methods
    private func fieldsValid() -> Bool {
        return email ? textFields[0].text != "" && textFields[1].text != "" && textFields[2].text != "" : (textFields[0].text != "" && textFields[1].text != "" && textFields[2].text != "") && textFields[1].text == textFields[2].text
    }
    
    @objc private func textFieldDidChange() {
        saveButton.enabled = fieldsValid()
    }
    
    private func handleFirebaseError(error: NSError) {
//        switch error.code {
//            
//        case FAuthenticationError.EmailTaken.rawValue:
//            self.errorAlert("There is already an account with this email.")
//            break
//        case FAuthenticationError.NetworkError.rawValue:
//            self.errorAlert("There is a problem with the network, please try again in a few moments.")
//            break
//        case FAuthenticationError.InvalidEmail.rawValue:
//            self.errorAlert("The email you entered is invalid.")
//            break
//        case FAuthenticationError.UserDoesNotExist.rawValue:
//            self.errorAlert("There is no registered account with that email.")
//            break
//        case FAuthenticationError.InvalidPassword.rawValue:
//            self.errorAlert("The password you entered is incorrect.")
//            break
//        default:
//            break
//            
//        }
    }
    
    private func stopProgressHud() {
        dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    private func startProgressHud() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    private func errorAlert(message: String) {
        alertController?.title = "Error"
        alertController!.message = message
        presentViewController(alertController!, animated: true, completion: nil)
    }
    
    private func successAlert(message: String) {
        alertController?.title = "Success"
        alertController?.message = message
        presentViewController(alertController!, animated: true, completion: nil)
    }
    
    // actions
    @IBAction func tappedSave(sender: AnyObject) {
//        startProgressHud()
//        if email {
//            FirebaseManager.sharedRootRef.changeEmailForUser(User.sharedModel.email, password: textFields[2].text, toNewEmail: textFields[1].text, withCompletionBlock: { error in
//                self.stopProgressHud()
//                if let error = error {
//                    self.textFields[1].text = ""
//                    self.textFields[2].text = ""
//                    self.handleFirebaseError(error)
//                } else {
//                    User.sharedModel.email = self.textFields[1].text!
//                    self.textFields[0].text = User.sharedModel.email
//                    self.textFields[1].text = ""
//                    self.textFields[2].text = ""
//                    FirebaseManager.sharedRootRef.childByAppendingPath("users").childByAppendingPath(User.sharedModel.uid).childByAppendingPath("email").setValue(User.sharedModel.email)
//                    NSUserDefaults.standardUserDefaults().setObject(User.sharedModel.dict(), forKey: "userData")
//                    NSUserDefaults.standardUserDefaults().synchronize()
//                    self.successAlert("Successfully changed email.")
//                }
//            })
//        } else {
//            FirebaseManager.sharedRootRef.changePasswordForUser(User.sharedModel.email, fromOld: textFields[0].text, toNew: textFields[1].text, withCompletionBlock: { error in
//                self.stopProgressHud()
//                for textField in self.textFields {
//                    textField.text = ""
//                }
//                
//                if let error = error {
//                    self.handleFirebaseError(error)
//                } else {
//                    self.successAlert("Successfully changed password.")
//                }
//            })
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.enabled = false
        
        // init alert controller
        alertController = UIAlertController(title: "Error", message: "Error", preferredStyle: .Alert)
        let okayAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Default, handler: { value in
            self.alertController!.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController!.addAction(okayAction)
        
        navigationItem.title = email ? "Change Email" : "Change Password"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseID = indexPath.section == 0 ? "passwordCell" : "confirmCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseID, forIndexPath: indexPath)

        (cell as! PasswordCell).textField.attributedPlaceholder = NSAttributedString(string: email ? emailPlaceholders[indexPath.row] : passwordPlaceholders[indexPath.row], attributes: [
                NSForegroundColorAttributeName: UIColor.placeholderGray(),
                NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 17.0)!
                ])
        (cell as! PasswordCell).textField.addTarget(self, action: #selector(textFieldDidChange), forControlEvents: .EditingChanged)
        (cell as! PasswordCell).textField.secureTextEntry = !email || indexPath.row == 2
        
        if email && indexPath.row == 0 {
            (cell as! PasswordCell).textField.text = User.sharedModel.email
            (cell as! PasswordCell).textField.enabled = false
        }
        
        textFields.append((cell as! PasswordCell).textField)

        return cell
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
