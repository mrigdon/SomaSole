//
//  CreateBasicsViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/10/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import TextFieldEffects
import ALCameraViewController

class CreateBasicsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let genderForPickerIndex = [
        0: "Male",
        1: "Female"
    ]
    
    var heightFeet: Int?
    var heightInches: Int?
    var weight: Float?
    var male: Bool?
    var dateOfBirth: NSDate?
    var profileImage: UIImage?
    
    var heightPicker: UIPickerView?
    var genderPicker: UIPickerView?
    var dateOfBirthPicker: UIDatePicker?
    
    @IBOutlet weak var profilePictureButton: UIButton!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var firstNameField: KaedeTextField!
    @IBOutlet weak var lastNameField: KaedeTextField!
    @IBOutlet weak var heightField: KaedeTextField!
    @IBOutlet weak var weightField: KaedeTextField!
    @IBOutlet weak var genderField: KaedeTextField!
    @IBOutlet weak var dateOfBirthField: KaedeTextField!
    
    func heightForPickerIndex(index: Int) -> Int {
        return 11 - index
    }
    
    func stringFromDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter.stringFromDate(date)
    }
    
    func anyFieldsEmpty() -> Bool {
        return firstNameField.text?.characters.count == 0 || lastNameField.text?.characters.count == 0 || heightField.text?.characters.count == 0 || weightField.text?.characters.count == 0 || genderField.text?.characters.count == 0 || dateOfBirthField.text?.characters.count == 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // disable button
        nextButton.enabled = false
        
        // init height picker
        heightPicker = UIPickerView()
        heightPicker?.dataSource = self
        heightPicker?.delegate = self
        heightField.inputView = heightPicker
        
        // init gender picker
        genderPicker = UIPickerView()
        genderPicker?.dataSource = self
        genderPicker?.delegate = self
        genderField.inputView = genderPicker
        
        // init date of birth picker
        dateOfBirthPicker = UIDatePicker()
        dateOfBirthPicker?.datePickerMode = .Date
        dateOfBirthField.inputView = dateOfBirthPicker
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedProfilePicture(sender: AnyObject) {
        let cameraViewController = CameraViewController(croppingEnabled: true, completion: { image in
            // dismiss camera view
            self.dismissViewControllerAnimated(true, completion: nil)
            
            // set image view
            self.profileImage = image.0
            self.profilePictureView.image = self.profileImage
            
            // make select image button transparent
            self.profilePictureButton.backgroundColor = UIColor.clearColor()
            self.profilePictureButton.setTitle("", forState: UIControlState.Normal)
            
            // set sharedUser image
            User.sharedModel.profileImage = image.0
        })
        
        presentViewController(cameraViewController, animated: true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        heightField.resignFirstResponder()
        weightField.resignFirstResponder()
        genderField.resignFirstResponder()
        dateOfBirthField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // handle pickers
        if textField == heightField {
            heightFeet = heightForPickerIndex((heightPicker?.selectedRowInComponent(0))!)
            heightInches = heightForPickerIndex((heightPicker?.selectedRowInComponent(1))!)
            heightField.text = "\(heightFeet!)' \(heightInches!)\""
        }
        else if textField == weightField {
            weight = Float(weightField.text!)
        }
        else if textField == genderField {
            male = Bool(~(genderPicker?.selectedRowInComponent(0))!)
            genderField.text = genderForPickerIndex[(genderPicker?.selectedRowInComponent(0))!]
        }
        else if textField == dateOfBirthField {
            dateOfBirth = dateOfBirthPicker?.date
            dateOfBirthField.text = stringFromDate(dateOfBirth!)
        }
        
        // enable button if all fields done
        if anyFieldsEmpty() {
            nextButton.enabled = false
        }
        else {
            nextButton.enabled = true
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerView == heightPicker {
            return 2
        }
        else {
            return 1
        }
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
            if row == 0 {
                male = true
            }
            else {
                male = false
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == heightPicker {
            return 11
        }
        else {
            return 2
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == heightPicker {
            // feet column
            if component == 0 {
                return "\(11-row) feet"
            }
            // inches column
            else {
                return "\(11-row) inches"
            }
        }
        else {
            if row == 0 {
                return "Male"
            }
            else {
                return "Female"
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // set user fields
        User.sharedModel.firstName = firstNameField.text
        User.sharedModel.lastName = lastNameField.text
        User.sharedModel.height = Float(heightFeet!) + (Float(heightInches!) / 12)
        User.sharedModel.weight = weight
        User.sharedModel.male = male
        User.sharedModel.dateOfBirth = dateOfBirth
        User.sharedModel.profileImage = profileImage
    }

}
