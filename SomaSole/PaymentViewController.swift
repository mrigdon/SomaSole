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
    
    
    // outlets
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var paymentTextField: STPPaymentCardTextField!
    
    // methods
    private func startProgressHud() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    private func stopProgressHud() {
        dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    private func handleStripeError(error: NSError) {
        
    }
    
    // actions
    @IBAction func tappedSave(sender: AnyObject) {
        let card = paymentTextField.cardParams
        STPAPIClient.sharedClient().createTokenWithCard(card, completion: { token, error in
            if let error = error {
                self.handleStripeError(error)
            }
            else {
                
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
