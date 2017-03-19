//
//  InterpolateAction.swift
//  TweenKit
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public class InterpolationAction<T: Tweenable>: FiniteTimeAction, SchedulableAction {
  
    // MARK: - Public
    
    public var easing = Easing.linear
    
    public init(from startValue: T, to endValue: T, duration: Double, update: @escaping (_: T) -> ()) {
        
        self.duration = duration
        self.startValue = startValue
        self.endValue = endValue
        self.updateHandler = update
    }
    
    // MARK: - Properties
    
    public var startValue: T! // Make private - set in initialiser
    public var endValue: T! // Make private - set in initialiser
    public var duration = Double(0)
    public var reverse = false
    var updateHandler: (_: T) -> () = {_ in}


    // MARK: - Methods
    
    public func update(t: Double) {
        
        // Apply easing
        var t = t
        t = easing.apply(t: t)
        
        // Calculate value
        let newValue = startValue.lerp(t: t, end: endValue)
        
        // Call the update handler
        updateHandler(newValue)
    }
    
}
 

