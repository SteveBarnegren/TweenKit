//
//  InterpolateAction.swift
//  TweenKit
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public class InterpolationAction<T: Tweenable>: Action<T> {
    
    public var startValue: T! // Make private - set in initialiser
    public var endValue: T! // Make private - set in initialiser
    
    public var easing = Easing.linear
    
    public init(from startValue: T, to endValue: T, duration: Double, update: @escaping (_: T) -> ()) {
        super.init()
        
        self.duration = duration
        self.startValue = startValue
        self.endValue = endValue
        self.updateHandler = update
    }
    
    override public func updateWithTime(t: Double) {
        
        // Apply easing
        var t = t
        t = easing.apply(t: t)
        
        // Calculate value
        let newValue = startValue.lerp(t: t, end: endValue)
        
        // Call the update handler
        updateHandler(newValue)
    }
    
}
 

