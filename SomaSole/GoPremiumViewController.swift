//
//  GoPremiumViewController.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 6/15/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import StoreKit
import MBProgressHUD

extension GoPremiumViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        stopProgressHud()
        if response.products.count > 0 {
            let product = response.products[0]
            let payment = SKPayment(product: product)
            SKPaymentQueue.defaultQueue().addTransactionObserver(self)
            SKPaymentQueue.defaultQueue().addPayment(payment)
        }
    }
    
    func request(request: SKRequest, didFailWithError error: NSError) {
        stopProgressHud()
        errorAlert("Something went wrong, please try again later.")
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        let transaction = transactions[0]
        if transaction.payment.productIdentifier == "monthly" && transaction.transactionState == .Purchased {
            if transaction.error != nil {
                errorAlert("Something went wrong, please try again later.")
            } else {
                User.sharedModel.premium = true
                FirebaseManager.sharedRootRef.childByAppendingPath("users").childByAppendingPath(User.sharedModel.uid).setValue(User.sharedModel.dict())
                NSUserDefaults.standardUserDefaults().setObject(User.sharedModel.dict(), forKey: "userData")
                NSUserDefaults.standardUserDefaults().synchronize()
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}

class GoPremiumViewController: UIViewController {
    
    // variables
    var errorAlertController: UIAlertController?
    var successAlertController: UIAlertController?

    // outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // actions
    @IBAction func tappedCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tappedStart(sender: AnyObject) {
        startProgressHud()
        let productID: Set = ["monthly"]
        let request = SKProductsRequest(productIdentifiers: productID)
        request.delegate = self
        request.start()
    }
    
    // methods
    private func ui(closure: () -> Void) {
        dispatch_async(dispatch_get_main_queue(), {
            closure()
        })
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        
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
