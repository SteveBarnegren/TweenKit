//
//  File.swift
//  TweenKit
//
//  Created by Steve Barnegren on 19/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public class Sequence: FiniteTimeAction {
    
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
    
    public func willBecomeActive() {
        onBecomeActive()
    }
    
    public func didBecomeInactive() {
        onBecomeInactive()
        lastRunAction = nil
    }
    
    public func willBegin() {
    }
    
    public func didFinish() {
        
        // finish the final action
        if let lastAction = reverse ? actions.first : actions.last {
            lastAction.didFinish()
            lastAction.didBecomeInactive()
        }
        
    }
    
    public func update(t: CFTimeInterval) {
        
        let elapsedTime = t * duration
        let enumeratedActions = reverse ? actions.reversed().enumerated() : actions.enumerated()
        
        // Get the last run action index
        var lastRunIndex = -1
        if let last = lastRunAction {
            for (index, action) in enumeratedActions {
                if action === last {
                    lastRunIndex = index
                }
            }
        }
        
        // Calculate action offsets
        var offsets = [Double]()
        var offsetPos = 0.0
        offsets.append(offsetPos)
        actions.dropLast().forEach{
            offsetPos += $0.duration
            offsets.append(offsetPos)
        }
        
        // Update actions
        for (index, action) in enumeratedActions {
            
            let offset = reverse ? offsets.reversed()[index] : offsets[index]
            
            // skip if we havn't passed the last run action
            if index < lastRunIndex {
                continue
            }
            
            // Start the action?
            if action !== lastRunAction {
                action.willBecomeActive()
                action.willBegin()
            }
            
            // Update the action
            let actionElapsed = ((elapsedTime - offset) / action.duration)
                .constrained(min: 0, max: action.duration)
            
            action.update(t: actionElapsed)
            lastRunAction = action
            
            // Continue to the next action?
            let continueToNext: Bool
            
            if reverse {
                continueToNext = elapsedTime < offset && index != actions.count - 1
            }
            else{
                continueToNext = elapsedTime > offset + action.duration && index != actions.count - 1
            }
            
            if continueToNext {
                action.didFinish()
                action.didBecomeInactive()
            }
            else{
                break
            }
            
        }
        
    }
 
}
