//
//  Action.swift
//  TweenKit
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

// MARK: - Shedulable Action

public protocol SchedulableAction {
    
    var onBecomeActive: () -> () {get set}
    var onBecomeInactive: () -> () {get set}
    
    func willBecomeActive()
    func didBecomeInactive()
    
    func willBegin()
    func didFinish()
}

// MARK: - Finite Time Action

public protocol FiniteTimeAction : SchedulableAction {
    
    var duration: Double {get}
    var reverse: Bool {get set}
    
    func update(t: CFTimeInterval)
}

// MARK: - Trigger Action

public protocol TriggerAction: FiniteTimeAction {
    func trigger()
}

extension TriggerAction {
    var duration: Double {
        return 0
    }
}

// MARK: - Infinite Time Action

public protocol InfiniteTimeAction : SchedulableAction {
    func update(elapsedTime: CFTimeInterval)
}


// MARK: - ****** FiniteTimeActionClassWrapper ******

// Some of the container actions rely on identiy comparison (===), so will wrap the action in a class
class FiniteTimeActionClassWrapper{
    var action: FiniteTimeAction
    
    init(action: FiniteTimeAction) {
        self.action = action
    }
}

extension FiniteTimeAction {
    func inClassWrapper() -> FiniteTimeActionClassWrapper {
        return FiniteTimeActionClassWrapper(action: self)
    }
}
