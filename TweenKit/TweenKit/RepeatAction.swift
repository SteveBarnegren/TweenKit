//
//  RepeatAction.swift
//  TweenKit
//
//  Created by Steve Barnegren on 19/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public class RepeatAction: FiniteTimeAction, SchedulableAction {
    
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
    
    // MARK: - Private Methods
    
    public func update(t: CFTimeInterval) {
        
        let actionT = ( t * Double(repeats) ).fract
        action.update(t: actionT)
    }
    
}

public extension FiniteTimeAction {
    
    public func repeated(_ times: Int) -> RepeatAction {
        return RepeatAction(action: self, times: times)
    }
}
