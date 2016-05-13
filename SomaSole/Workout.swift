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

enum WorkoutTag: Int {
    case Core, UpperBody, LowerBody, TotalBody
}

class Movement: NSObject {

    var title: String
    var time: Int
    var finished = false
    
    init(title: String, time: Int) {
        self.title = title
        self.time = time
    }

}

class Circuit: NSObject {
    
    var numSets: Int
    var movements: [Movement] = []
    
    init(data: [String:AnyObject]) {
        self.numSets = data["sets"] as! Int
        
        let movementsData = data["movements"] as! [[String:Int]]
        for movementData in movementsData {
            let movement = Movement(title: movementData.first!.0, time: movementData.first!.1)
            movements.append(movement)
        }
    }
    
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
    var name: String
    var time: Int
    var intensity: Int
    var workoutDescription: String
    var imageName: String
    var circuits: [Circuit] = []
    var tags = [WorkoutTag]()
    
    init(index: Int, data: [String:AnyObject]) {
        self.index = WorkoutIndex(rawValue: index)!
        self.name = data["name"] as! String
        self.imageName = workoutImageNames[self.index]!
        self.time = data["time"] as! Int
        self.intensity = data["intensity"] as! Int
        self.workoutDescription = data["description"] as! String
        
        let circuitsData = data["circuits"] as! [[String:AnyObject]]
        for circuitData in circuitsData {
            let circuit = Circuit(data: circuitData)
            circuits.append(circuit)
        }
        
        let tagsData = data["tags"] as! [Int]
        for tagData in tagsData {
            self.tags.append(WorkoutTag(rawValue: tagData)!)
        }
    }
    
    func printAll() {
        print("index: \(index)")
        print("name: \(name)")
        print("time: \(time)")
        print("intensity: \(intensity)")
        print("description: \(workoutDescription)")
    }
}
