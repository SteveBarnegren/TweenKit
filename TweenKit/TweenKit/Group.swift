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
    
    public internal(set) var duration: CFTimeInterval = 0.0
    private var actions = [SchedulableAction]()
    private var lastUpdateT = 0.0
    
    // MARK: - Private methods
    
    func calculateDuration() {
        duration = actions.reduce(0){ max($0, $1.duration) }
    }
    
    public func updateWithTime(t: CFTimeInterval) {
        
        let elapsedTime = t * duration
        let lastElapsedTime = lastUpdateT * duration
        
        for action in actions {
            
            // Update the action if it is in progress
            if elapsedTime < action.duration {
                action.updateWithTime(t: elapsedTime / action.duration)
            }
            
            // Finish the Action if finished in the last update
            else if lastElapsedTime < action.duration, elapsedTime > action.duration {
                action.updateWithTime(t: 1)
            }
            
        }
        
        lastUpdateT = t
    }
    
}
