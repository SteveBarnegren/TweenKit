//
//  File.swift
//  TweenKit
//
//  Created by Steve Barnegren on 19/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public class Sequence: FiniteTimeAction, SchedulableAction {
    
    // MARK: - Public
    
    public var onBecomeActive: () -> () = {}
    public var onBecomeInactive: () -> () = {}
    
    public var reverse = false {
        didSet {
            actions.forEach{ $0.reverse = reverse }
        }
    }

    public init() {
    }
    
    public init(actions: [FiniteTimeAction]) {
        actions.forEach{
            add(action: $0)
        }
    }
    
    public init(actions: FiniteTimeAction...) {
        actions.forEach{
            add(action: $0)
        }
    }

    public func add(action: FiniteTimeAction) {
        actions.append(action)
        calculateDuration()
    }
    
    // MARK: - Private Properties
    
    public private(set) var duration = Double(0)
    
    var actions = [FiniteTimeAction]()
    var lastRunAction: FiniteTimeAction?
    
    // MARK: - Private Methods

    func calculateDuration() {
        duration = actions.reduce(0) { $0 + $1.duration }
    }
    
    public func update(t: CFTimeInterval) {
        
        let elapsedTime = t * duration

        var offset = CFTimeInterval(0)
        var passedLastAction = false
        
        if lastRunAction == nil {
            passedLastAction = true
        }
        
        for action in actions {
            
            guard offset + action.duration > elapsedTime else {
                offset += action.duration
                continue
            }
            
            // If we've changed action, finish the last one
            if lastRunAction !== action {
                
                // Finish the last action
                if let last = lastRunAction {
                    last.update(t: reverse ? 0 : 1)
                    last.didBecomeInactive()
                }
                
                // start the new action
                action.willBecomeActive()
                lastRunAction = action
            }
            
            // Update the current action
            let actionElapsed = (elapsedTime - offset) / action.duration
            action.update(t: actionElapsed)
            lastRunAction = action
            
            break
        }
    }
    
}
