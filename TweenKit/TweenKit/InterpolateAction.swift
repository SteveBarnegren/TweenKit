//
//  InterpolateAction.swift
//  TweenKit
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public class InterpolationAction<T: Tweenable>: Action<T> {
    
    override public func updateWithTime(t: Double) {
        
        // Just perform a linear interpolation for now
        let newValue = startValue.lerp(t: t, end: endValue)
        
        // Call the update handler
        updateHandler(newValue)
    }
    
}
 

