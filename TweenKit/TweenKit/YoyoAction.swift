//
//  YoyoAction.swift
//  TweenKit
//
//  Created by Steve Barnegren on 19/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

/** Animates inner action to end and then back to beginning */
public class YoyoAction: FiniteTimeAction {
    
    // MARK: - Types
    
    enum State {
        case idle
        case forwards
        case backwards
    }
    
    // MARK: - Public
    
    public var onBecomeActive: () -> () = {}
    public var onBecomeInactive: () -> () = {}
    
    public var reverse = false {
        didSet{
            if reverse != oldValue, state != .idle {
                action.reverse = !action.reverse
            }
        }
    }

    /**
     Create with action to yoyo
     - Parameter action: The action to yoyo
     */
    public init(action: FiniteTimeAction) {
        
        self.action = action
        self.duration = action.duration * 2
    }
    
    // MARK: - Private Properties
    
    public internal(set) var duration: Double
    var action: FiniteTimeAction
    var state = State.idle
    
    // MARK: - Private Methods
    
    public func willBecomeActive() {
        onBecomeActive()
        action.willBecomeActive()
    }

    public func didBecomeInactive() {
        onBecomeInactive()
        action.didBecomeInactive()
    }
    
    public func willBegin() {
        self.update(t: reverse ? 1.0 : 0.0)
    }
    
    public func didFinish() {
        
        self.update(t: reverse ? 0.0 : 1.0)
        action.didFinish()
        state = .idle
    }
    
    public func update(t: CFTimeInterval) {
        
        /*
         The order of state changes and setReverse is important here. The inner action should receive the following calls:
         
         - will begin
         - will finish
         - reverse = true
         - will begin
         - will finish
 
         The inner action is 'invoked twice' (two begin/finish calls), and it has the correct reverse state at the time of each call
         There are unit tests that test the call order, please run them after making changes
         */
        
        if t < 0.5 {
            
            if state == .idle {
                action.reverse = reverse
                action.willBegin()
            }
            
            if state == .backwards {
                action.didFinish()
                action.reverse = reverse
                action.willBegin()
            }
            
            let actionT = t * 2
            action.update(t: actionT)
            
            state = .forwards
        }
        else{
            
            if state == .idle {
                action.reverse = !reverse
                action.willBegin()
            }
            
            if state == .forwards {
                action.didFinish()
                action.reverse = !reverse
                action.willBegin()
            }

            let actionT = 1-((t - 0.5) * 2);
            action.update(t: actionT)
            
            state = .backwards
        }
    }
}

public extension FiniteTimeAction {
    
    func yoyo() -> YoyoAction {
        return YoyoAction(action: self)
    }
}
