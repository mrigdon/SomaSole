//
//  Payment2ViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 6/18/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Stripe
import MBProgressHUD
import SwiftyJSON

extension UIColor {
    var coreImageColor: CoreImage.CIColor? {
        return CoreImage.CIColor(color: self)
    }
}

extension Payment2ViewController: STPPaymentCardTextFieldDelegate {
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        submitButton.enabled = textField.valid
    }
}

class Payment2ViewController: UITableViewController {
    
    // constants
    let successStatusCode = 200
    let invalidCardStatusCode = 402
    
    // variables
    var errorAlertController: UIAlertController?
    var successAlertController: UIAlertController?

    // outlets
    @IBOutlet weak var paymentTextField: STPPaymentCardTextField!
    @IBOutlet weak var promoCodeTextField: UITextField!
    @IBOutlet weak var submitButton: UIBarButtonItem!
    
    // methods
    @objc private func dismissKeyboard() {
        paymentTextField.resignFirstResponder()
    }
    
    private func startProgressHud() {
        ui {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }
    }
    
    private func stopProgressHud() {
        ui {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
    private func successAlert(message: String) {
        ui {
            self.successAlertController?.message = message
            self.presentViewController(self.successAlertController!, animated: true, completion: nil)
        }
    }
    
    private func errorAlert(message: String) {
        ui {
            self.errorAlertController?.message = message
            self.presentViewController(self.errorAlertController!, animated: true, completion: nil)
        }
    }
    
    private func ui(closure: () -> Void) {
        dispatch_async(dispatch_get_main_queue(), {
            closure()
        })
    }
    
    private func handleStripeError(error: NSError) {
        self.errorAlert("Something went wrong, please try again later.")
    }
    
    private func createBackendChargeWithToken(token: STPToken, completion: () -> Void) {
        let promoCode = promoCodeTextField.text ?? ""
        let url = NSURL(string: "https://somasole-payments.herokuapp.com/charge")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let body = "stripeToken=\(token.tokenId)&email=\(User.sharedModel.email)&promoCode=\(promoCode)"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        let task = session.dataTaskWithRequest(request) { data, response, error -> Void in
            self.stopProgressHud()
            if let _ = error {
                self.errorAlert("Something went wrong, please try again later.")
            } else if let code = (response as? NSHTTPURLResponse)?.statusCode {
                if code == self.successStatusCode {
                    let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: [])
                    let swiftyJSON = JSON(json)
                    User.sharedModel.stripeID = swiftyJSON["id"].stringValue
                    User.sharedModel.premium = true
                    FirebaseManager.sharedRootRef.childByAppendingPath("users").childByAppendingPath(User.sharedModel.uid).setValue(User.sharedModel.dict())
                    NSUserDefaults.standardUserDefaults().setObject(User.sharedModel.dict(), forKey: "userData")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    self.successAlert("Congratulations! You are now subscribed to the Monthly Premium Plan!")
                } else if code == self.invalidCardStatusCode {
                    self.errorAlert("It looks like your card was invalid.")
                }
            }
        }
        task.resume()
    }
    
    // actions
    @IBAction func tappedSubmit(sender: AnyObject) {
        paymentTextField.resignFirstResponder()
        startProgressHud()
        let card = paymentTextField.cardParams
        STPAPIClient.sharedClient().createTokenWithCard(card, completion: { token, error in
            if let error = error {
                self.handleStripeError(error)
            } else {
                self.createBackendChargeWithToken(token!, completion: {})
            }
        })
    }
    
    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.enabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        paymentTextField.borderWidth = 0
        let grayConstant: CGFloat = 0.666666686534882
        promoCodeTextField.attributedPlaceholder = NSAttributedString(string: "Promo Code", attributes: [
            NSForegroundColorAttributeName: UIColor(red: grayConstant, green: grayConstant, blue: grayConstant, alpha: 1.0),
            NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 17.0)!
            ])
        
        // alert controller
        errorAlertController = UIAlertController(title: "Error", message: "Error", preferredStyle: .Alert)
        let errorOkayAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Default, handler: { value in
            self.ui {
                self.errorAlertController!.dismissViewControllerAnimated(true, completion: nil)
            }
        })
        errorAlertController!.addAction(errorOkayAction)
        successAlertController = UIAlertController(title: "Success!", message: "Success", preferredStyle: .Alert)
        let successOkayAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Default, handler: { value in
            self.ui {
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
        })
        successAlertController!.addAction(successOkayAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
