//
//  Profile2ViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 6/10/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Toucan
import MBProgressHUD
import Firebase

extension Float {
    var heightString: String {
        let feet = floor(self)
        let inches = (self - feet) * 12
        return "\(Int(feet))' \(Int(inches))\""
    }
    
    var weightString: String {
        return "\(self) lbs"
    }
}

extension NSDate {
    var simpleString: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.stringFromDate(self)
    }
}

extension Bool {
    var genderString: String {
        return self ? "Male" : "Female"
    }
}

extension UIImage {
    var roundImage: UIImage {
        return Toucan(image: self).maskWithEllipse().image
    }
}

extension Profile2ViewController: UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}

extension Profile2ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ProfileCell
        
        let field = fields[indexPath.row]
        cell.keyLabel.text = field.0
        cell.valueField.text = field.1
        textFields.append(cell.valueField)
        
        return cell
    }
}

extension Profile2ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

class Profile2ViewController: UIViewController {
    
    enum TextFieldIndex {
        case FirstName, LastName, Email, Password, Height, Weight, DOB, Gender
    }
    
    // variables
    var fields = [(String, String)]()
    var alertController: UIAlertController?
    var textFields = [UITextField]()

    // outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var basicTableViewHeight: NSLayoutConstraint!
    
    // methods
    private func ui(closure: () -> Void) {
        dispatch_async(dispatch_get_main_queue(), {
            closure()
        })
    }
    
    func startProgressHud() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    func stopProgressHud() {
        dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    private func successAlert(message: String) {
        alertController?.title = "Success"
        alertController?.message = message
        presentViewController(alertController!, animated: true, completion: nil)
    }
    
    private func errorAlert(message: String) {
        alertController?.title = "Error"
        alertController?.message = message
        presentViewController(alertController!, animated: true, completion: nil)
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
    @IBAction func tappedSave(sender: AnyObject) {
        startProgressHud()
        
        FirebaseManager.sharedRootRef.childByAppendingPath("users").childByAppendingPath(User.sharedModel.uid).setValue(User.data(), withCompletionBlock: { error, firebase in
            self.stopProgressHud()
            if error != nil {
                self.handleFirebaseError(error)
            }
            else {
                self.successAlert("Your info has been updated")
                User.saveToUserDefaults()
            }
        })
    }
    
    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fields = [
            ("First Name", User.sharedModel.firstName!),
            ("Last Name", User.sharedModel.lastName!),
            ("Email", User.sharedModel.email!),
            ("Password", "XXXXXXXX"),
            ("Height", User.sharedModel.height!.heightString),
            ("Weight", User.sharedModel.weight!.weightString),
            ("D.O.B.", User.sharedModel.dateOfBirth!.simpleString),
            ("Gender", User.sharedModel.male!.genderString)
        ]
        
        alertController = UIAlertController(title: "Error", message: "Error", preferredStyle: .Alert)
        let okayAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Default, handler: { value in
            self.alertController!.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController!.addAction(okayAction)

        ui {
            self.basicTableViewHeight.constant = 352 // 44 * 8
            self.imageView.image = User.sharedModel.profileImage?.roundImage
        }
    }
    
    override func viewDidAppear(animated: Bool) {

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
