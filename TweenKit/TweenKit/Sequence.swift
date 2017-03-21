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
        
        // Update actions
        var offset = reverse ? duration - actions.last!.duration : 0.0
        for (index, action) in enumeratedActions {
            
            func incrementOffset() {
                offset += reverse ? -action.duration : action.duration
            }
            
            // skip if we havn't passed the last run action
            if index < lastRunIndex {
                incrementOffset()
                continue
            }
            
            // Start the action?
            if action !== lastRunAction {
                action.willBecomeActive()
                action.willBegin()
            }
            
            // Update the action
            let actionElapsed = ((elapsedTime - offset) / action.duration).constrained(min: 0, max: action.duration)
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
            
            // Update the offset
            incrementOffset()
        }
        
        /*
 public func update(t: CFTimeInterval) {
 
 let elapsedTime = t * duration
 
 // Get the last run action index
 var lastRunIndex = reverse ? actions.count : -1
 if let last = lastRunAction {
 for (index, action) in actions.enumerated() {
 if action === last {
 lastRunIndex = index
 }
 }
 }
 
 // Update actions
 var offset = reverse ? duration : 0.0
 let enumeratedActions = reverse ? actions.reversed().enumerated() : actions.enumerated()
 for (index, action) in enumeratedActions {
 
 func incrementOffset() {
 offset += reverse ? -action.duration : action.duration
 }
 
 // skip if we havn't passed the last run action
 func isBeforeLastRunIndex(idx: Int) -> Bool {
 return self.reverse ? idx > lastRunIndex : idx < lastRunIndex
 }
 
 if isBeforeLastRunIndex(idx: index) {
 incrementOffset()
 continue
 }
 
 // Start the action?
 if action !== lastRunAction {
 action.willBecomeActive()
 action.willBegin()
 }
 
 // Update the action
 let actionOffset = reverse ? offset - action.duration : offset
 let actionElapsed = ((elapsedTime - actionOffset) / action.duration).constrained(min: 0, max: action.duration)
 action.update(t: actionElapsed)
 lastRunAction = action
 
 // Continue to the next action?
 let continueToNext: Bool
 
 if reverse {
 continueToNext = elapsedTime < offset - action.duration
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
 
 // Update the offset
 incrementOffset()
 }
*/
 
    }
 
}
