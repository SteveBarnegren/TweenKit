//
//  RepeatAction.swift
//  TweenKit
//
//  Created by Steve Barnegren on 19/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

/** Repeats an inner action a specified number of times */
public class RepeatAction: FiniteTimeAction {
    
    // MARK: - Public
    
    public var onBecomeActive: () -> () = {}
    public var onBecomeInactive: () -> () = {}
    
    /**
     Create with an action to repeat
     - Parameter action: The action to repeat
     - Parameter times: The number of repeats
     */
    public init(action: FiniteTimeAction, times: Int) {
        self.action = action
        self.repeats = times
        self.duration = action.duration * Double(times)
    }
    
    // MARK: - Private Properties
    public var reverse: Bool = false {
        didSet{
            action.reverse = reverse
        }
    }

    public internal(set) var duration: Double
    var action: FiniteTimeAction
    let repeats: Int
    var lastRepeatNumber = 0
    
    // MARK: - Private Methods
    
    public func willBecomeActive() {
        lastRepeatNumber = 0
        action.willBecomeActive()
        onBecomeActive()
    }
    
    public func didBecomeInactive() {
        
        action.didBecomeInactive()
        onBecomeInactive()
    }
    
    public func willBegin() {
        action.willBegin()
    }
    
    public func didFinish() {
        
        // We might have skipped over the action, so we still need to run the full cycle
        (lastRepeatNumber..<repeats-1).forEach{ _ in
            self.action.didFinish()
            self.action.willBegin()
        }

        action.didFinish()
    }
    
    public func update(t: CFTimeInterval) {
        
        let repeatNumber = Int( t * Double(repeats) ).constrained(max: repeats-1)
        
        (lastRepeatNumber..<repeatNumber).forEach{ _ in
            self.action.didFinish()
            self.action.willBegin()
        }
    
        let actionT = ( t * Double(repeats) ).fract

        // Avoid situation where fract is 0.0 because t is 1.0
        if t > 0 && actionT == 0  {
            action.update(t: 1.0)
        }
        else{
            action.update(t: actionT)
        }
        
        lastRepeatNumber = repeatNumber
    }
    
}

public extension FiniteTimeAction {
    
    func repeated(_ times: Int) -> RepeatAction {
        return RepeatAction(action: self, times: times)
    }
}
