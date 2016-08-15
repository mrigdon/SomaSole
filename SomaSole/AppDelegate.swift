//
//  AppDelegate.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/4/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import AWSCognito
import AWSS3
import FBSDKCoreKit
import SwiftyJSON
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    enum ReceiptStatus: Int {
        case Valid = 0
        case Sandbox = 21007
    }
    
    enum ReceiptEnvironment: String {
        case Production = "https://buy.itunes.apple.com/verifyReceipt"
        case Sandbox = "https://sandbox.itunes.apple.com/verifyReceipt"
    }
    
    private func validateReceipt(environment: ReceiptEnvironment = .Production) {
        let receiptURL = NSBundle.mainBundle().appStoreReceiptURL
        let receipt = NSData(contentsOfURL: receiptURL!)
        let requestContents = [
            "receipt-data": receipt!.base64EncodedStringWithOptions([]),
            "password": "5e6e3b769b504bc9bb175786fe7a6114"
        ]
        let requestData = try! NSJSONSerialization.dataWithJSONObject(requestContents, options: [])
        let storeURL = NSURL(string: environment.rawValue)
        let request = NSMutableURLRequest(URL: storeURL!)
        request.HTTPMethod = "POST"
        request.HTTPBody = requestData
        let (params, _) = Alamofire.ParameterEncoding.URL.encode(request, parameters: nil)
        Alamofire.request(params).responseJSON { response in
            let data = try! NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions.AllowFragments)
            let json = JSON(data)
            let status = ReceiptStatus(rawValue: json["status"].intValue)
            
            if status == .Valid {
                let expiresTime = json["receipt"]["in_app"][0]["expires_date_ms"].doubleValue / 1000
                let currentTime = NSDate().timeIntervalSince1970
                let premium = currentTime < expiresTime
                if User.sharedModel.premium != premium {
                    User.sharedModel.premium = premium
                    User.sharedModel.save()
                }
            } else if status == .Sandbox {
                self.validateReceipt(.Sandbox)
            }
        }
    }
    
    override init() {
        super.init()
        
        // enable firebase offine capabilities
        Firebase.defaultConfig().persistenceEnabled = true
        Firebase(url: "http://somasole.firebaseio.com").keepSynced(true)
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Initialize the Amazon Cognito credentials provider
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType:.USEast1,
            identityPoolId:"us-east-1:d3bf8475-a252-4c2f-af5f-8a40d942ac30"
        )
        let configuration = AWSServiceConfiguration(
            region:.USWest1,
            credentialsProvider:credentialsProvider
        )
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
        
        // iqmanager
        IQKeyboardManager.sharedManager().enable = true
        
        // validate receipt
        validateReceipt()
    
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance()
            .application(application, openURL: url,
                         sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

