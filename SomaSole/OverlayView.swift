//
//  OverlayView.swift
//  SomaSole
//
//  Created by Matthew Rigdon on 6/14/16.
//  Copyright © 2016 SomaSole. All rights reserved.
//

import UIKit

protocol OverlayViewDelegate: class {
    func tappedOverlay()
}

class OverlayView: UIView {

    weak var delegate: OverlayViewDelegate?

}
