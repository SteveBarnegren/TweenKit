//
//  ActionScrubber.swift
//  TweenKit
//
//  Created by Steven Barnegren on 29/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public class ActionScrubber {
    
    // MARK: - Public
    
    public init(action: FiniteTimeAction) {
        self.action = action
    }
    
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
        let t = t.constrained(min: 0.0, max: 1.0)
        action.update(t: t)
        
        // Save t
        lastUpdateT = t
    }
    
    // MARK: - Properties

    private var action: FiniteTimeAction
    private var hasBegun = false
    private var lastUpdateT: Double?
    
}
