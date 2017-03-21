//
//  GroupAction.swift
//  TweenKit
//
//  Created by Steve Barnegren on 19/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

/** Groups run multiple actions in parallel */
public class Group: FiniteTimeAction, SchedulableAction {
    
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
        
        if let trigger = action as? TriggerAction {
            triggerActions.append(trigger)
        }
        else{
            let wrappedAction = GroupActionWrapper(action: action)
            wrappedActions.append(wrappedAction)
            calculateDuration()
        }
    }
    
    // MARK: - Private Properties
    
    public internal(set) var duration = Double(0)
    private var triggerActions = [TriggerAction]()
    private var wrappedActions = [GroupActionWrapper]()
    private var lastUpdateT = 0.0
    
    // MARK: - Private methods
    
    func calculateDuration() {
        duration = wrappedActions.reduce(0){ max($0, $1.action.duration) }
    }
    
    public func willBecomeActive() {
        onBecomeActive()
    }
    
    public func didBecomeInactive() {
        onBecomeInactive()
    }
    
    public func willBegin() {
        
        // Invoke trigger actions
        if reverse == false {
            triggerActions.forEach{
                $0.trigger()
            }
        }
        
        // Set actions in progress
        wrappedActions.forEach{
            $0.state = .inProgress
        }
    }
    
    public func didFinish() {
        
        // Finish actions
        wrappedActions.forEach{
            $0.state = .finished
        }
        
        // If we're being called in reverse, now we should call the trigger actions
        if reverse == true {
            triggerActions.forEach{
                $0.trigger()
            }
        }
    }

    public func update(t: CFTimeInterval) {
        
        let elapsedTime = t * duration
        let lastElapsedTime = lastUpdateT * duration
        
        for wrapper in wrappedActions {
            
            // Update the action if it is in progress
            if elapsedTime < wrapper.action.duration {
                
                wrapper.state = .inProgress
                wrapper.action.update(t: elapsedTime / wrapper.action.duration)
            }
            
            // Finish the Action if finished in the last update
            else if lastElapsedTime < wrapper.action.duration, elapsedTime > wrapper.action.duration {
                wrapper.action.update(t: reverse ? 0 : 1)
                wrapper.state = .finished
            }
        }
        
        lastUpdateT = t
    }
    
}

class GroupActionWrapper {
    
    enum State {
        case notStarted
        case inProgress
        case finished
    }

    init(action: FiniteTimeAction) {
        self.action = action
    }
    
    let action: FiniteTimeAction
    
    var state = State.notStarted {
        didSet{
            
            if state == oldValue {
                return
            }
            
            switch state {
            case .inProgress:
                action.willBecomeActive()
                action.willBegin()
                
                if let trigger = action as? TriggerAction {
                    trigger.trigger()
                }
                
            case .finished:
                action.didFinish()
                action.didBecomeInactive()
            case .notStarted: break
            }
        }
    }
}
