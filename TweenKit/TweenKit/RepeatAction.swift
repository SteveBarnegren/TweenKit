//
//  RepeatAction.swift
//  TweenKit
//
//  Created by Steve Barnegren on 19/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public class RepeatAction: FiniteTimeAction {
    
    // MARK: - Public
    
    public var onBecomeActive: () -> () = {}
    public var onBecomeInactive: () -> () = {}
    
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
    let action: FiniteTimeAction
    let repeats: Int
    var lastRepeatNumber = 0
    
    // MARK: - Private Methods
    
    public func willBecomeActive() {
        onBecomeInactive()
        action.willBecomeActive()
    }
    
    public func didBecomeInactive() {
        action.didBecomeInactive()
        onBecomeInactive()
    }
    
    public func willBegin() {
        action.willBegin()
    }
    
    public func didFinish() {
        action.didFinish()
    }
    
    public func update(t: CFTimeInterval) {
        
        let repeatNumber = Int( t * Double(repeats) ).constrained(max: repeats-1)
        
        (lastRepeatNumber..<repeatNumber).forEach{ _ in
            self.action.didFinish()
            self.action.willBegin()
        }
        
        let actionT = ( t * Double(repeats) ).fract
        action.update(t: actionT)
        
        lastRepeatNumber = repeatNumber
    }
    
}

public extension FiniteTimeAction {
    
    public func repeated(_ times: Int) -> RepeatAction {
        return RepeatAction(action: self, times: times)
    }
}
