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
            wrappedActions.forEach{ $0.action.reverse = reverse }
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
        wrappedActions.append( action.inClassWrapper() )
        calculateDuration()
        calculateOffsets()
    }
    
    // MARK: - Private Properties
    
    public private(set) var duration = Double(0)
    
    private var wrappedActions = [FiniteTimeActionClassWrapper]()
    private var offsets = [Double]()
    private var lastRunAction: FiniteTimeActionClassWrapper?
    
    // MARK: - Private Methods

    private func calculateDuration() {
        duration = wrappedActions.reduce(0) { $0 + $1.action.duration }
    }
    
    private func calculateOffsets() {
        offsets = [Double]()
        var offsetPos = 0.0
        offsets.append(offsetPos)
        wrappedActions.dropLast().forEach{
            offsetPos += $0.action.duration
            offsets.append(offsetPos)
        }
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
        if let lastAction = reverse ? wrappedActions.first : wrappedActions.last {
            lastAction.action.didFinish()
            lastAction.action.didBecomeInactive()
        }
        
    }
    
    public func update(t: CFTimeInterval) {
        
        let elapsedTime = t * duration
        let enumeratedActions = reverse ? wrappedActions.reversed().enumerated() : wrappedActions.enumerated()
        
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
        for (index, wrapper) in enumeratedActions {
            
            let offset = reverse ? offsets.reversed()[index] : offsets[index]
            
            // skip if we havn't passed the last run action
            if index < lastRunIndex {
                continue
            }
            
            // Start the action?
            if wrapper !== lastRunAction {
                wrapper.action.willBecomeActive()
                wrapper.action.willBegin()
            }
            
            // Update the action
            let actionT = ((elapsedTime - offset) / wrapper.action.duration)
                .constrained(min: 0, max: 1.0)
            
            wrapper.action.update(t: actionT)
            lastRunAction = wrapper
            
            // Continue to the next action?
            let continueToNext: Bool
            
            if reverse {
                continueToNext = elapsedTime < offset && index != wrappedActions.count - 1
            }
            else{
                continueToNext = elapsedTime > offset + wrapper.action.duration && index != wrappedActions.count - 1
            }
            
            if continueToNext {
                wrapper.action.didFinish()
                wrapper.action.didBecomeInactive()
            }
            else{
                break
            }
            
        }
        
    }
 
}
