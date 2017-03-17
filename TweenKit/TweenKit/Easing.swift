//
//  Easing.swift
//  TweenKit
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

enum Easing {
    case linear
    case sineIn
    case sineOut
    case sineInOut

    func apply(t: Double) -> Double {
        
        switch self {
        case .linear:
            return t
        case .sineIn:
            return -1.0 * cos(t * M_PI_2) + 1.0
        case .sineOut:
            return sin(t * M_PI_2)
        case .sineInOut:
            return -0.5 * (cos(M_PI*t) - 1.0);
        }
    }
    
    
    
}
