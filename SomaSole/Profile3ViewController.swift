//
//  Profile3ViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 6/18/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import MBProgressHUD
import Firebase
import Toucan
import Masonry
import SwiftString
import Alamofire

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
    
    func formattedForTableHeader(size: Int) -> UIImage {
        return Toucan(image: self).resize(CGSize(width: size, height: size)).image
    }
}

extension Float {
    var feet: Int {
        return Int(floor(self))
    }
    var inches: Int {
        return Int((self - floor(self)) * 12)
    }
}

extension Int {
    var heightValue: Int {
        return 11 - self
    }
}

extension String {
    var heightValue: Float {
        let feetIndex = self.indexOf("'")
        let spaceIndex = self.indexOf(" ")
        let inchesIndex = self.indexOf("\"")
        
        let feet = Float(self.substring(0, length: feetIndex!))
        let inches = Float(self.substring(spaceIndex! + 1, length: inchesIndex! - spaceIndex! - 1))! / 12
        
        return feet! + inches
    }
    
    var weightValue: Float {
        let spaceIndex = self.indexOf(" ")
        
        return Float(self.substring(0, length: spaceIndex!))!
    }
    
    var dateOfBirthValue: NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter.dateFromString(self)!
    }
    
    var maleValue: Bool {
        return self == "Male"
    }
}

extension Profile3ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == textFields[TextFieldIndex.Height.hashValue] {
            let heightFeet = heightPicker.selectedRowInComponent(0).heightValue
            let heightInches = heightPicker.selectedRowInComponent(1).heightValue
            textField.text = "\(heightFeet)' \(heightInches)\""
        } else if textField == textFields[TextFieldIndex.Weight.hashValue] {
            let weight = Float(textField.text!)
            if let weight = weight {
                textField.text = "\(weight) lbs"
            }
        } else if textField == textFields[TextFieldIndex.Gender.hashValue] {
            male = Bool(~(genderPicker.selectedRowInComponent(0)))
            textField.text = genderPicker.selectedRowInComponent(0) == 0 ? "Male" : "Female"
        } else if textField == textFields[TextFieldIndex.DOB.hashValue] {
            let dateOfBirth = dateOfBirthPicker.date
            textField.text = dateOfBirth.simpleString
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == textFields[TextFieldIndex.Height.hashValue] {
            textField.selectedTextRange = textField.textRangeFromPosition(textField.beginningOfDocument, toPosition: textField.endOfDocument)
        } else if textField == textFields[TextFieldIndex.Weight.hashValue] {
            textField.selectedTextRange = textField.textRangeFromPosition(textField.beginningOfDocument, toPosition: textField.endOfDocument)
        } else if textField == textFields[TextFieldIndex.DOB.hashValue] {
            textField.selectedTextRange = textField.textRangeFromPosition(textField.beginningOfDocument, toPosition: textField.endOfDocument)
        } else if textField == textFields[TextFieldIndex.Gender.hashValue] {
            textField.selectedTextRange = textField.textRangeFromPosition(textField.beginningOfDocument, toPosition: textField.endOfDocument)
        }
    }
}

extension Profile3ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerView == heightPicker ? 2 : 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == heightPicker {
            if component == 0 {
                heightFeet = 11 - row
            } else {
                heightInches = 11 - row
            }
        } else {
            male = row == 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == heightPicker ? 11 : 2
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == heightPicker {
            return component == 0 ? "\(11-row) feet" : "\(11-row) inches"
        } else {
            return row == 0 ? "Male" : "Female"
        }
    }
}

class Profile3ViewController: UITableViewController {
    
    enum TextFieldIndex {
        case FirstName, LastName, Height, Weight, DOB, Gender
    }
    
    // variables
    var alertController: UIAlertController?
    var deleteController: UIAlertController = UIAlertController(title: "Are You Sure?", message: "If you are a premium member your billing will stop immediately and your money will not be refunded. Still sure? If so, enter password to confirm.", preferredStyle: .Alert)
    var confirmAction = UIAlertAction()
    var textFields = [UITextField]()
    var passwordField = UITextField()
    var anyFieldEmpty = false
    var heightPicker = UIPickerView()
    var genderPicker = UIPickerView()
    var dateOfBirthPicker = UIDatePicker()
    var male = false
    var heightFeet = 0
    var heightInches = 0
    var password = ""
    var data = [String:AnyObject]()
    
    // outlets
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
    
    @objc private func passwordFieldDidChange(sender: AnyObject) {
        let textField = sender as! UITextField
        password = textField.text!
        confirmAction.enabled = password != ""
    }
    
    // actions
    @IBAction func tappedSave(sender: AnyObject) {
        let oldData = User.sharedModel.dict()
        
        User.sharedModel.firstName = textFields[TextFieldIndex.FirstName.hashValue].text!
        User.sharedModel.lastName = textFields[TextFieldIndex.LastName.hashValue].text!
        User.sharedModel.height = textFields[TextFieldIndex.Height.hashValue].text!.heightValue
        User.sharedModel.weight = textFields[TextFieldIndex.Weight.hashValue].text!.weightValue
        User.sharedModel.dateOfBirth = textFields[TextFieldIndex.DOB.hashValue].text!.dateOfBirthValue
        User.sharedModel.male = textFields[TextFieldIndex.Gender.hashValue].text!.maleValue
        
        startProgressHud()
        FirebaseManager.sharedRootRef.childByAppendingPath("users").childByAppendingPath(User.sharedModel.uid).setValue(User.sharedModel.dict(), withCompletionBlock: { error, firebase in
            self.stopProgressHud()
            if error != nil {
                User.sharedModel = User(uid: User.sharedModel.uid, data: oldData)
                self.handleFirebaseError(error)
            } else {
                self.successAlert("Your info has been updated")
            }
        })
    }
    
    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // alert controller
        alertController = UIAlertController(title: "Error", message: "Error", preferredStyle: .Alert)
        let okayAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Default, handler: { value in
            self.alertController!.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController!.addAction(okayAction)
        
        // delete controller
        deleteController.addTextFieldWithConfigurationHandler { textField in
            textField.secureTextEntry = true
            textField.placeholder = "Password"
            textField.addTarget(self, action: #selector(self.passwordFieldDidChange(_:)), forControlEvents: .EditingChanged)
        }
        let nevermindAction = UIAlertAction(title: "Nevermind, Don't Delete", style: .Default, handler: { action in
            self.alertController!.dismissViewControllerAnimated(true, completion: nil)
        })
        confirmAction = UIAlertAction(title: "Yes, Delete it", style: .Destructive, handler: { action in
            self.startProgressHud()
            FirebaseManager.sharedRootRef.removeUser(User.sharedModel.email, password: self.password, withCompletionBlock: { error in
                if let error = error {
                    self.handleFirebaseError(error)
                } else {
                    FirebaseManager.sharedRootRef.childByAppendingPath("users").childByAppendingPath(User.sharedModel.uid).removeValue()
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "userData")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    if User.sharedModel.premium {
                        Alamofire.request(.POST, "https://somasole-payments.herokuapp.com/delete_customer/\(User.sharedModel.stripeID)").responseJSON { response in
                            if let _ = response.result.value {
                                self.stopProgressHud()
                                self.performSegueWithIdentifier("deleteSegue", sender: self)
                            }
                        }
                    } else {
                        self.stopProgressHud()
                        self.performSegueWithIdentifier("deleteSegue", sender: self)
                    }
                }
            })
        })
        confirmAction.enabled = false
        deleteController.addAction(nevermindAction)
        deleteController.addAction(confirmAction)
        
        // setup pickers
        setupPickers()
        
        // setup profile image
        let tableHeaderViewHeight: CGFloat = 152
        let tableHeaderViewPadding: CGFloat = 32
        tableView.tableHeaderView?.frame.size.height = tableHeaderViewHeight
        let tableHeaderView = UIView()
        tableHeaderView.frame.size.height = tableHeaderViewHeight
        let profileImageView = UIImageView(image: User.sharedModel.profileImage.roundImage.formattedForTableHeader(Int(tableHeaderViewHeight - tableHeaderViewPadding)))
        profileImageView.contentMode = .ScaleAspectFill
        profileImageView.frame.size.height = tableHeaderViewHeight - tableHeaderViewPadding
        profileImageView.frame.size.width = tableHeaderViewHeight - tableHeaderViewPadding
        tableHeaderView.addSubview(profileImageView)
        profileImageView.mas_makeConstraints { make in
            make.center.equalTo()(tableHeaderView)
        }
        tableView.tableHeaderView = tableHeaderView
    }
    
    override func viewDidAppear(animated: Bool) {
        ui {
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if User.sharedModel.facebook {
            return User.sharedModel.premium ? 3 : 4
        } else {
            return User.sharedModel.premium ? 4 : 5
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if User.sharedModel.facebook {
            if User.sharedModel.premium {
                return section == 0 ? 6 : 1
            } else {
                return section == 0 ? 1 : section == 1 ? 6 : 1
            }
        } else {
            if User.sharedModel.premium {
                return section == 0 ? 6 : section == 1 ? 2 : 1
            } else {
                return section == 0 ? 1 : section == 1 ? 6 : section == 2 ? 2 : 1
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellType = ""
        if User.sharedModel.facebook {
            if User.sharedModel.premium {
                cellType = indexPath.section == 0 ? "profileCell" : indexPath.section == 1 ? "logoutCell" : "deleteAccountCell"
            } else {
                cellType = indexPath.section == 0 ? "goPremiumCell" : indexPath.section == 1 ? "profileCell" : indexPath.section == 2 ? "logoutCell" : "deleteAccountCell"
            }
        } else {
            if User.sharedModel.premium {
                cellType = indexPath.section == 0 ? "profileCell" : indexPath.section == 1 && indexPath.row == 0 ? "changeEmailCell" : indexPath.section == 1 ? "changePasswordCell" : indexPath.section == 2 ? "logoutCell" : "deleteAccountCell"
            } else {
                cellType = indexPath.section == 0 ? "goPremiumCell" : indexPath.section == 1 ? "profileCell" : indexPath.section == 2 && indexPath.row == 0 ? "changeEmailCell" : indexPath.section == 2 ? "changePasswordCell" : indexPath.section == 3 ? "logoutCell" : "deleteAccountCell"
            }
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellType, forIndexPath: indexPath)
        
        if (User.sharedModel.premium && indexPath.section == 0) || (!User.sharedModel.premium && indexPath.section == 1) {
            let cell = cell as! ProfileCell
            if indexPath.row == TextFieldIndex.FirstName.hashValue {
                cell.keyLabel.text = "First Name"
                cell.valueField.text = User.sharedModel.firstName
            } else if indexPath.row == TextFieldIndex.LastName.hashValue {
                cell.keyLabel.text = "Last Name"
                cell.valueField.text = User.sharedModel.lastName
            } else if indexPath.row == TextFieldIndex.Height.hashValue {
                cell.keyLabel.text = "Height"
                cell.valueField.text = User.sharedModel.height.heightString
                cell.valueField.inputView = heightPicker
            } else if indexPath.row == TextFieldIndex.Weight.hashValue {
                cell.keyLabel.text = "Weight"
                cell.valueField.text = User.sharedModel.weight.weightString
                cell.valueField.keyboardType = .NumberPad
            } else if indexPath.row == TextFieldIndex.DOB.hashValue {
                cell.keyLabel.text = "D.O.B."
                cell.valueField.text = User.sharedModel.dateOfBirth.simpleString
                cell.valueField.inputView = dateOfBirthPicker
            } else if indexPath.row == TextFieldIndex.Gender.hashValue {
                cell.keyLabel.text = "Gender"
                cell.valueField.text = User.sharedModel.male.genderString
                cell.valueField.inputView = genderPicker
            }
            cell.valueField.addTarget(self, action: #selector(basicTextFieldDidChange(_:)), forControlEvents: .EditingChanged)
            cell.valueField.delegate = self
            textFields.append(cell.valueField)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !((User.sharedModel.premium && indexPath.section == 0) || (!User.sharedModel.premium && indexPath.section == 1))
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (User.sharedModel.facebook && ((User.sharedModel.premium && indexPath.section == 2) || (!User.sharedModel.premium && indexPath.section == 3))) || (!User.sharedModel.facebook && ((User.sharedModel.premium && indexPath.section == 3) || (!User.sharedModel.premium && indexPath.section == 4))) {
            presentViewController(deleteController, animated: true, completion: nil)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logoutSegue" {
            FirebaseManager.sharedRootRef.unauth()
            User.sharedModel = User()
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "userData")
            NSUserDefaults.standardUserDefaults().synchronize()
        } else if segue.identifier == "changeEmailSegue" {
            (segue.destinationViewController as! ChangePasswordViewController).email = true
        } else if segue.identifier == "changePasswordSegue" {
            (segue.destinationViewController as! ChangePasswordViewController).email = false
        }
    }
    
}
