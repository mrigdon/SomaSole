//
//  CreateBasicsViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/10/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import TextFieldEffects

class CreateBasicsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameField: KaedeTextField!
    @IBOutlet weak var lastNameField: KaedeTextField!
    @IBOutlet weak var heightField: KaedeTextField!
    @IBOutlet weak var weightField: KaedeTextField!
    @IBOutlet weak var genderField: KaedeTextField!
    @IBOutlet weak var dateOfBirthField: KaedeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        heightField.resignFirstResponder()
        weightField.resignFirstResponder()
        genderField.resignFirstResponder()
        dateOfBirthField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // set user fields
        let user = User.sharedModel
        user.firstName = firstNameField.text
        user.lastName = lastNameField.text
    }

}
