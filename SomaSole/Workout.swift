//
//  Workout.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 4/25/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

enum WorkoutIndex: Int {
    case AbShred, AnchorAbs, Armageddon, BackToBack, BootyBlaster, BoulderShoulders, CoolDown, GetFunctional, GroundAttack, Intensity, JumpTraining, LeanLegs, Obliques, Plank, PowerUp, PreParty, Stretch, Sweat, UpperBodyBlast
}

class Workout: NSObject {
    
    let workoutImageNames = [
        WorkoutIndex.AbShred: "ab_shred",
        WorkoutIndex.AnchorAbs: "anchor_abs",
        WorkoutIndex.Armageddon: "armageddon",
        WorkoutIndex.BackToBack: "back_to_back",
        WorkoutIndex.BootyBlaster: "booty_blaster",
        WorkoutIndex.BoulderShoulders: "boulder_shoulders",
        WorkoutIndex.CoolDown: "cool_down",
        WorkoutIndex.GetFunctional: "get_functional",
        WorkoutIndex.GroundAttack: "ground_attack",
        WorkoutIndex.Intensity: "intensity",
        WorkoutIndex.JumpTraining: "jump_training",
        WorkoutIndex.LeanLegs: "lean_legs",
        WorkoutIndex.Obliques: "obliques",
        WorkoutIndex.Plank: "plank",
        WorkoutIndex.PowerUp: "power_up",
        WorkoutIndex.PreParty: "pre_party",
        WorkoutIndex.Stretch: "stretch",
        WorkoutIndex.Sweat: "sweat",
        WorkoutIndex.UpperBodyBlast: "upper_body_blast"
    ]
    
    var index: WorkoutIndex
    var title: String
    var imageName: String
    
    init(index: WorkoutIndex, title: String) {
        self.index = index
        self.title = title
        self.imageName = workoutImageNames[self.index]!
    }
}
