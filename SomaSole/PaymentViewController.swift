//
//  PaymentViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 6/7/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Stripe
import MBProgressHUD

extension PaymentViewController: STPPaymentCardTextFieldDelegate {
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        saveButton.enabled = textField.valid
    }
}

class PaymentViewController: UIViewController {
    
    // constants
    let successStatusCode = 200
    let invalidCardStatusCode = 402
    
    // variables
    var errorAlertController: UIAlertController?
    var successAlertController: UIAlertController?
    
    // outlets
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var paymentTextField: STPPaymentCardTextField!
    
    // methods
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
        
    }
    
    private func createBackendChargeWithToken(token: STPToken, completion: () -> Void) {
        let url = NSURL(string: "https://somasole-payments.herokuapp.com/charge")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let body = "stripeToken=\(token.tokenId)&email=\(User.sharedModel.email!)"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        let task = session.dataTaskWithRequest(request) { data, response, error -> Void in
            self.stopProgressHud()
            if let error = error {
                print(error)
            } else if let code = (response as? NSHTTPURLResponse)?.statusCode {
                if code == self.successStatusCode {
                    User.sharedModel.premium = true
                    User.saveToUserDefaults()
                    User.sharedModel.saveToFirebase()
                    self.successAlert("Congratulations! You are now subscribed to the Monthly Premium Plan!")
                } else if code == self.invalidCardStatusCode {
                    self.errorAlert("It looks like your card was invalid.")
                }
            }
        }
        task.resume()
    }
    
    // actions
    @IBAction func tappedSave(sender: AnyObject) {
        paymentTextField.resignFirstResponder()
        startProgressHud()
        let card = paymentTextField.cardParams
        STPAPIClient.sharedClient().createTokenWithCard(card, completion: { token, error in
            if let error = error {
                self.handleStripeError(error)
            }
            else {
                self.createBackendChargeWithToken(token!, completion: {})
            }
        })
    }
    
    @IBAction func tappedCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.enabled = false
        paymentTextField.layer.borderWidth = 0
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
