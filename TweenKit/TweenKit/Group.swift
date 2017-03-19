//
//  GroupAction.swift
//  TweenKit
//
//  Created by Steve Barnegren on 19/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

/** Groups run multiple actions in parallel */
public class Group: SchedulableAction {
    
    // MARK: - Public
    
    public var reverse = false {
        didSet {
            actions.forEach{ $0.reverse = reverse }
        }
    }
    
    public init() {
    }
    
    public init(actions: [SchedulableAction]) {
        actions.forEach{
            add(action: $0)
        }
    }
    
    public init(actions: SchedulableAction...) {
        actions.forEach{
            add(action: $0)
        }
    }
    
    public func add(action: SchedulableAction) {
        actions.append(action)
        calculateDuration()
    }
    
    // MARK: - Private Properties
    
    public internal(set) var duration = ActionDuration.finite(0)
    private var actions = [SchedulableAction]()
    private var lastUpdateT = 0.0
    
    // MARK: - Private methods
    
    func calculateDuration() {
        let value = actions.reduce(0){ max($0, $1.finiteDuration) }
        duration = .finite(value)
    }
    
    public func updateWithTime(t: CFTimeInterval) {
        
        let elapsedTime = t * finiteDuration
        let lastElapsedTime = lastUpdateT * finiteDuration
        
        for action in actions {
            
            // Update the action if it is in progress
            if elapsedTime < action.finiteDuration {
                action.updateWithTime(t: elapsedTime / action.finiteDuration)
            }
            
            // Finish the Action if finished in the last update
            else if lastElapsedTime < action.finiteDuration, elapsedTime > action.finiteDuration {
                action.updateWithTime(t: reverse ? 0 : 1)
            }
        }
        
        lastUpdateT = t
    }
    
}
