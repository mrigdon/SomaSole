//
//  ArrowButton.swift
//  Pods
//
//  Created by Prabaharan Elangovan on 08/02/16.
//
//

import Foundation

@IBDesignable public class ArrowButton: ShapeButton, ArrowDesignable {
    
    @IBInspectable public var arrowDirection: String = ArrowDirection.Default.rawValue
    
    override public func config() {
        drawArrow()
    }
}

