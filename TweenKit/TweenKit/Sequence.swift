//
//  File.swift
//  TweenKit
//
//  Created by Steve Barnegren on 19/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public class Sequence: SchedulableAction {
    
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
    
    public private(set) var duration = 0.0
    
    var actions = [SchedulableAction]()
    
    // MARK: - Private Methods

    func calculateDuration() {
        duration = actions.reduce(0) { $0 + $1.duration }
    }
    
    public func updateWithTime(t: CFTimeInterval) {
        
        let elapsedTime = t * duration

        var offset = CFTimeInterval(0)
        
        for action in actions {
            
            guard offset + action.duration > elapsedTime else {
                offset += action.duration
                continue
            }
            
            // TODO: Keep a reference to the last action, if it has changed, can pass 0 or 1 t
            
            let actionElapsed = (elapsedTime - offset) / action.duration
            action.updateWithTime(t: actionElapsed)
            
            break
        }
    }
    
    
    
    
    
}
