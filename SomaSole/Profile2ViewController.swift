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
        cell.valueField.addTarget(self, action: #selector(basicTextFieldDidChange(_:)), forControlEvents: .EditingChanged)
        if indexPath.row == TextFieldIndex.Height.hashValue {
            cell.valueField.inputView = heightPicker
        }
        else if indexPath.row == TextFieldIndex.DOB.hashValue {
            cell.valueField.inputView = dateOfBirthPicker
        }
        else if indexPath.row == TextFieldIndex.Gender.hashValue {
            cell.valueField.inputView = genderPicker
        }
        else if indexPath.row == TextFieldIndex.Weight.hashValue {
            cell.valueField.keyboardType = .NumberPad
        }
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

extension Profile2ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerView == heightPicker ? 2 : 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // height picker
        if pickerView == heightPicker {
            if component == 0 {
                heightFeet = 11 - row
            }
            else {
                heightInches = 11 - row
            }
        }
            // gender picker
        else {
            male = row == 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == heightPicker ? 11 : 2
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == heightPicker {
            return component == 0 ? "\(11-row) feet" : "\(11-row) inches"
        }
        else {
            return row == 0 ? "Male" : "Female"
        }
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
    var anyFieldEmpty = false
    var heightPicker = UIPickerView()
    var genderPicker = UIPickerView()
    var dateOfBirthPicker = UIDatePicker()
    var male = false
    var heightFeet = 0
    var heightInches = 0

    // outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var basicTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
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
    
    private func allFieldsValid() -> Bool {
        for textField in textFields {
            if textField.text!.isEmpty {
                return false
            }
        }
        
        return true
    }
    
    private func setupPickers() {
        // init height picker
        heightPicker.dataSource = self
        heightPicker.delegate = self
        
        // init gender picker
        genderPicker.dataSource = self
        genderPicker.delegate = self
        
        // init date of birth picker
        dateOfBirthPicker.datePickerMode = .Date
    }
    
    @objc private func basicTextFieldDidChange(sender: AnyObject) {
        saveButton.enabled = allFieldsValid()
    }
    
    // actions
    @IBAction func tappedSave(sender: AnyObject) {
        startProgressHud()
        
        // TODO: -
//        User.sharedModel.firstName = textFields[TextFieldIndex.FirstName.hashValue].text
//        User.sharedModel.lastName = textFields[TextFieldIndex.LastName.hashValue].text
//        User.sharedModel.email = textFields[TextFieldIndex.Email.hashValue].text
//        User.sharedModel.firstName = textFields[TextFieldIndex.FirstName.hashValue].text
        
//        FirebaseManager.sharedRootRef.childByAppendingPath("users").childByAppendingPath(User.sharedModel.uid).setValue(User.data(), withCompletionBlock: { error, firebase in
//            self.stopProgressHud()
//            if error != nil {
//                self.handleFirebaseError(error)
//            }
//            else {
//                self.successAlert("Your info has been updated")
//                User.saveToUserDefaults()
//            }
//        })
    }
    
    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fields for text fields
        fields = [
//            ("First Name", User.sharedModel.firstName!),
//            ("Last Name", User.sharedModel.lastName!),
//            ("Email", User.sharedModel.email!),
//            ("Password", "XXXXXXXX"),
//            ("Height", User.sharedModel.height!.heightString),
//            ("Weight", User.sharedModel.weight!.weightString),
//            ("D.O.B.", User.sharedModel.dateOfBirth!.simpleString),
//            ("Gender", User.sharedModel.male!.genderString)
        ]
        
        // alert controller
        alertController = UIAlertController(title: "Error", message: "Error", preferredStyle: .Alert)
        let okayAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Default, handler: { value in
            self.alertController!.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController!.addAction(okayAction)
        
        // setup pickers
        setupPickers()
        
        // setup fields
//        male = User.sharedModel.male!
//        heightFeet = User.sharedModel.height!.feet
//        heightInches = User.sharedModel.height!.inches

        // ui
        ui {
            self.basicTableViewHeight.constant = 352 // 44 * 8
//            self.imageView.image = User.sharedModel.profileImage?.roundImage
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
