//
//  Action.swift
//  TweenKit
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

// MARK: - Shedulable Action

/** Protcol for any action that can be added to an ActionScheduler instance */
public protocol SchedulableAction : class {
    
    /** Called when the action bhecomes active */
    var onBecomeActive: () -> () {get set}
    
    /** Called when the action becomes inactive */
    var onBecomeInactive: () -> () {get set}
    
    func willBecomeActive()
    func didBecomeInactive()
    
    func willBegin()
    func didFinish()
}

// MARK: - Finite Time Action

/** Protocol for Actions that have a finite duration */
public protocol FiniteTimeAction : SchedulableAction {
    
    var duration: Double {get}
    var reverse: Bool {get set}
    func update(t: CFTimeInterval)
}

// MARK: - Trigger Action

/** Protocol for actions that trigger an event and have no duration */
public protocol TriggerAction: FiniteTimeAction {
    func trigger()
}

extension TriggerAction {
    var duration: Double {
        return 0
    }
}

// MARK: - Infinite Time Action

/** Protocol for actions that run indefinitely */
public protocol InfiniteTimeAction : SchedulableAction {
    func update(elapsedTime: CFTimeInterval)
}
