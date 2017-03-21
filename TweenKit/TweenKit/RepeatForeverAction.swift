//
//  RepeatForeverAction.swift
//  TweenKit
//
//  Created by Steve Barnegren on 19/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public class RepeatForeverAction: InfiniteTimeAction {

    // MARK: - Public

    public var onBecomeActive: () -> () = {}
    public var onBecomeInactive: () -> () = {}
    
    public init(action: FiniteTimeAction) {
        self.action = action;
    }
    
    // MARK: - Private Properties
    let action: FiniteTimeAction
    var lastRepeatNumber = 0

    // MARK: - Private Methods
    
    public func willBecomeActive() {
        onBecomeActive()
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
    
    public func update(elapsedTime: CFTimeInterval) {
        
        let repeatNumber = Int(elapsedTime / action.duration)
        
        (lastRepeatNumber..<repeatNumber).forEach{ _ in
            self.action.didFinish()
            self.action.willBegin()
        }

        let actionT = (elapsedTime / action.duration).fract
        action.update(t: actionT)
        
        lastRepeatNumber = repeatNumber
    }
}

public extension FiniteTimeAction {
    
    public func repeatedForever() -> RepeatForeverAction {
        return RepeatForeverAction(action: self)
    }
}
