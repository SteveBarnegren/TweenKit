//
//  Easing.swift
//  TweenKit
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

let kPERIOD: Double = 0.3
let M_PI_X_2: Double = Double.pi * 2.0

/** The easing (timing function) that an animation should use */
public enum Easing: Int {
    
    // Linear
    case linear
    
    // Sine
    case sineIn
    case sineOut
    case sineInOut

    // Exponential
    case exponentialIn
    case exponentialOut
    case exponentialInOut
    
    // Back
    case backIn
    case backOut
    case backInOut
    
    // Bounce
    case bounceIn
    case bounceOut
    case bounceInOut
    
    // Elastic
    case elasticIn
    case elasticOut
    case elasticInOut
    
    public func apply(t: Double) -> Double {
        
        switch self {
            
        // **** Linear ****
        case .linear:
            return t
            
        // **** Sine ****
        case .sineIn:
            return -1.0 * cos(t * (Double.pi/2)) + 1.0
            
        case .sineOut:
            return sin(t * (Double.pi/2))
            
        case .sineInOut:
            return -0.5 * (cos(Double.pi*t) - 1.0)
        
        // **** Exponential ****
        case .exponentialIn:
            return (t==0.0) ? 0.0 : pow(2.0, 10.0 * (t/1.0 - 1.0)) - 1.0 * 0.001;
            
        case .exponentialOut:
            return (t==1.0) ? 1.0 : (-pow(2.0, -10.0 * t/1.0) + 1.0);
            
        case .exponentialInOut:
            var t = t
            t /= 0.5;
            if (t < 1.0) {
                t = 0.5 * pow(2.0, 10.0 * (t - 1.0))
            }
            else {
                t = 0.5 * (-pow(2.0, -10.0 * (t - 1.0) ) + 2.0);
            }
            return t;
        
        // **** Back ****
        case .backIn:
            let overshoot = 1.70158
            return t * t * ((overshoot + 1.0) * t - overshoot);
            
        case .backOut:
            let overshoot = 1.70158
            var t = t
            t = t - 1.0;
            return t * t * ((overshoot + 1.0) * t + overshoot) + 1.0;
            
        case .backInOut:
            let overshoot = 1.70158 * 1.525
            var t = t
            t = t * 2.0;
            if (t < 1.0) {
                return (t * t * ((overshoot + 1.0) * t - overshoot)) / 2.0;
            }
            else {
                t = t - 2.0;
                return (t * t * ((overshoot + 1.0) * t + overshoot)) / 2.0 + 1.0;
            }
            
        // **** Bounce ****
        case .bounceIn:
            var newT = t
            if(t != 0.0 && t != 1.0) {
                newT = 1.0 - bounceTime(t: 1.0 - t)
            }
            return newT;
            
        case .bounceOut:
            var newT = t;
            if(t != 0.0 && t != 1.0) {
                newT = bounceTime(t: t)
            }
            return newT;
            
        case .bounceInOut:
            let newT: Double
            if( t == 0.0 || t == 1.0) {
                newT = t;
            }
            else if (t < 0.5) {
                var t = t
                t = t * 2.0;
                newT = (1.0 - bounceTime(t: 1.0-t) ) * 0.5
            } else {
                newT = bounceTime(t: t * 2.0 - 1.0) * 0.5 + 0.5
            }
            
            return newT;
            
        // **** Elastic ****
        case .elasticIn:
            var newT = 0.0
            if (t == 0.0 || t == 1.0) {
                newT = t
            }
            else {
                var t = t
                let s = kPERIOD / 4.0;
                t = t - 1;
                newT = -pow(2, 10 * t) * sin( (t-s) * M_PI_X_2 / kPERIOD);
            }
            return newT;
            
        case .elasticOut:
            var newT = 0.0
            if (t == 0.0 || t == 1.0) {
                newT = t
            } else {
                let s = kPERIOD / 4;
                newT = pow(2.0, -10.0 * t) * sin( (t-s) * M_PI_X_2 / kPERIOD) + 1
            }
            return newT
            
        case .elasticInOut:
            var newT = 0.0;
            
            if( t == 0.0 || t == 1.0 ) {
                newT = t;
            }
            else {
                var t = t
                t = t * 2.0;
                let s = kPERIOD / 4;
                
                t = t - 1.0;
                if( t < 0 ) {
                    newT = -0.5 * pow(2, 10.0 * t) * sin((t - s) * M_PI_X_2 / kPERIOD);
                }
                else{
                    newT = pow(2, -10.0 * t) * sin((t - s) * M_PI_X_2 / kPERIOD) * 0.5 + 1.0;
                }
            }
            return newT;
        }
    }
    
    // Helpers
    
    func bounceTime(t: Double) -> Double {
        
        var t = t
        
        if (t < 1.0 / 2.75) {
            return 7.5625 * t * t
        }
        else if (t < 2.0 / 2.75) {
            t -= 1.5 / 2.75
            return 7.5625 * t * t + 0.75
        }
        else if (t < 2.5 / 2.75) {
            t -= 2.25 / 2.75
            return 7.5625 * t * t + 0.9375
        }
        
        t -= 2.625 / 2.75
        return 7.5625 * t * t + 0.984375
    }
    
    
    
}
