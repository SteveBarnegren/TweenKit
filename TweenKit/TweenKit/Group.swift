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
    
    public internal(set) var duration = Double(0)
    private var actions = [FiniteTimeAction]()
    private var lastUpdateT = 0.0
    
    // MARK: - Private methods
    
    public func willBecomeActive() {
        onBecomeActive()
        actions.forEach{
            $0.willBecomeActive()
        }
    }
    
    func calculateDuration() {
        duration = actions.reduce(0){ max($0, $1.duration) }
    }
    
    public func update(t: CFTimeInterval) {
        
        let elapsedTime = t * duration
        let lastElapsedTime = lastUpdateT * duration
        
        for action in actions {
            
            // Update the action if it is in progress
            if elapsedTime < action.duration {
                action.update(t: elapsedTime / action.duration)
            }
            
            // Finish the Action if finished in the last update
            else if lastElapsedTime < action.duration, elapsedTime > action.duration {
                action.update(t: reverse ? 0 : 1)
                action.didBecomeInactive()
            }
        }
        
        lastUpdateT = t
    }
    
}
