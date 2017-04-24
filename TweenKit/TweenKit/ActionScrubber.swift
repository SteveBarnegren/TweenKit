//
//  ActionScrubber.swift
//  TweenKit
//
//  Created by Steven Barnegren on 29/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

/** 
 Used to manually control an action's time.
 Init with an action, and scrub using one of the update methods.
 Only supports FiniteTimeActions (RepeatForever not supported)
 */
public class ActionScrubber {
    
    // MARK: - Public
    
    public init(action: FiniteTimeAction) {
        self.action = action
    }
    
    /**
     Scrub the contained action to a specified time
     - parameter t: t (0-1) to scrub to
     */
    public func update(t: Double) {
        
        // Start the action
        if !hasBegun {
            action.willBecomeActive()
            action.willBegin()
            hasBegun = true
        }
        
        // Set correct reverse state
        var reverse = false
        
        if let lastT = lastUpdateT {
            reverse = t < lastT
        }
        
        if action.reverse != reverse {
            action.reverse = reverse
        }
        
        // Update
        //let t = t.constrained(min: 0.0, max: 1.0)
        action.update(t: t)
        
        // Save t
        lastUpdateT = t
    }
    
    /**
     Scrub the contained action to a specified time
     - parameter elapsedTime: The time to scrub to in seconds
     */
    public func update(elapsedTime: Double) {
        update(t: elapsedTime / action.duration)
    }
    
    // MARK: - Properties
    
    private var action: FiniteTimeAction
    private var hasBegun = false
    private var lastUpdateT: Double?
    
}
