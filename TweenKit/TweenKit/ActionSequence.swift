//
//  File.swift
//  TweenKit
//
//  Created by Steve Barnegren on 19/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

class SequenceActionWrapper {
    
    enum State {
        case notStarted
        case inProgress
        case finished
    }
    
    var state = State.notStarted
    var action: FiniteTimeAction
    
    init(action: FiniteTimeAction) {
        self.action = action
    }
}

/** Runs multiple actions in sequence */
public class ActionSequence: FiniteTimeAction {
    
    // MARK: - Public
    
    /**
     Create with actions
     - Parameter actions: Array of actions the sequence should contain
     */
    public init(actions: [FiniteTimeAction]) {
        actions.forEach{
            add(action: $0)
        }
    }
    
    /**
     Create with actions
     - Parameter actions: Actions the sequence should contain
     */
    public init(actions: FiniteTimeAction...) {
        actions.forEach{
            add(action: $0)
        }
    }
    
    public var onBecomeActive: () -> () = {}
    public var onBecomeInactive: () -> () = {}
    
    public var reverse = false {
        didSet {
            wrappedActions.forEach{ $0.action.reverse = reverse }
        }
    }

    // MARK: - Private Properties
    
    public private(set) var duration = Double(0)
    
    private var wrappedActions = [SequenceActionWrapper]()
    private var offsets = [Double]()
    private var lastRunAction: SequenceActionWrapper?
    
    // MARK: - Private Methods
    
    private func add(action: FiniteTimeAction) {
        wrappedActions.append( SequenceActionWrapper(action: action) )
        calculateDuration()
        calculateOffsets()
    }

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
    }
    
    public func willBegin() {
        
        // Reset
        lastRunAction = nil
        
        wrappedActions.forEach{
            $0.state = .notStarted
        }
    }
    
    public func didFinish() {
        
        // Finish all of the inner actions
        for wrapper in wrappedActions {
        
            if wrapper.state == .notStarted {
                wrapper.action.willBecomeActive()
                wrapper.action.willBegin()
                wrapper.state = .inProgress
            }
            
            if wrapper.state == .inProgress {
                wrapper.action.update(t: reverse ? 0.0 : 1.0)
                
                if let trigger = wrapper.action as? TriggerAction {
                    trigger.trigger()
                }
                
                wrapper.action.didFinish()
                wrapper.action.didBecomeInactive()
            }
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
                wrapper.state = .inProgress
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
                //wrapper.action.update(t: reverse ? 0.0 : 1.0)
                
                if let trigger = wrapper.action as? TriggerAction {
                    trigger.trigger()
                }
                
                wrapper.action.didFinish()
                wrapper.action.didBecomeInactive()
                wrapper.state = .finished
            }
            else{
                break
            }
            
        }
        
    }
 
}
