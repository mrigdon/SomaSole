//
//  SoundManager.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 9/5/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit
import AudioToolbox

class SoundManager: NSObject {

    static let sharedManager = SoundManager()
    
    func playSound(named name: String) {
        if let soundURL = Bundle.main.url(forResource: name, withExtension: "wav") {
            var sound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &sound)
            AudioServicesPlaySystemSound(sound)
        }
    }
    
}
