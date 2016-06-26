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
import Stripe
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    override init() {
        super.init()
        
        // enable firebase offine capabilities
        Firebase.defaultConfig().persistenceEnabled = true
        Firebase(url: "http://somasole.firebaseio.com").keepSynced(true)
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //FirebaseManager.uploadArticle()
        Stripe.setDefaultPublishableKey("pk_test_yAloS0mmAIglRzjupfHB1Bpp")
        
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
        
        // try to get logged in user
        let userData = NSUserDefaults.standardUserDefaults().objectForKey("userData") as? Dictionary<String, AnyObject>
        
        // if not logged in yet, send to login screen
        if userData == nil {
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
            return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        FirebaseManager.sharedRootRef.authUser(User.sharedModel.email, password: User.sharedModel.password, withCompletionBlock: { error, data in })
        
        // if is logged in
        User.populateFields(userData!)
    
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

