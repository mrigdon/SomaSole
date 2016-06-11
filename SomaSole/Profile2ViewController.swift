//
//  Profile2ViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 6/10/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Toucan

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
        
        return cell
    }
}

class Profile2ViewController: UIViewController {
    
    var fields = [(String, String)]()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var basicTableViewHeight: NSLayoutConstraint!
    
    private func ui(closure: () -> Void) {
        dispatch_async(dispatch_get_main_queue(), {
            closure()
        })
    }
    
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
