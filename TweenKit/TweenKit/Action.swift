//
//  Action.swift
//  TweenKit
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

// MARK: - SchedulableAction

public enum ActionDuration {
    case finite(_: Double)
    case infinite
}



public protocol SchedulableAction: class {
    var duration: ActionDuration {get}
    var reverse: Bool {get set}
    func updateWithTime(t: CFTimeInterval)
}

extension SchedulableAction {
    var finiteDuration: CFTimeInterval {
        switch duration {
        case .finite(let value):
            return value
        case .infinite:
            fatalError()
        }
    }
}

// MARK: - Action (Base)

public class Action<T: Tweenable> : SchedulableAction {
    
    // MARK: - Properties
    public internal(set) var duration = ActionDuration.finite(0)
    public var reverse: Bool = false
    var updateHandler: (_: T) -> () = {_ in}
    
    public init() {
    }
    
    // MARK: - Schedulable
    
    public func updateWithTime(t: Double) {
        fatalError("Subclasses must override")
    }
}
 


