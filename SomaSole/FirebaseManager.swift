//
//  FirebaseManager.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 5/17/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import Firebase

class FirebaseManager: NSObject {

    static var sharedRootRef = FIRDatabase.database().reference()
    static var sharedStorage = FIRStorage.storage().referenceForURL("gs://project-7570309397895349159.appspot.com")
    
}
