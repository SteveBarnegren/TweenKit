//
//  Animation.swift
//  TweenKit
//
//  Created by Steve Barnegren on 18/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public class Animation : Equatable {
    
    public func run(){
        Scheduler.shared.add(animation: self)
    }
    
    var elapsedTime: CFTimeInterval = 0
    
    var duration: CFTimeInterval {
        return action.duration
    }
    
    
    private let action: SchedulableAction!
    
    public init(action: SchedulableAction) {
        self.action = action
    }
    
    func update(t: Double) {
        action.updateWithTime(t: t)
    }
}

// MARK: - Equatable
public func ==(rhs: Animation, lhs: Animation) -> Bool {
    return rhs === lhs
}
