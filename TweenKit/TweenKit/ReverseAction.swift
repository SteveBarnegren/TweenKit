//
//  ReverseAction.swift
//  TweenKit
//
//  Created by Steven Barnegren on 21/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

class ReverseAction: FiniteTimeAction {
    
    // MARK: - Public
    
    var onBecomeActive: () -> () = {}
    var onBecomeInactive: () -> () = {}
    
    init(action: FiniteTimeAction) {
        self.action = action
    }
    
    // MARK: - Private Properties
    let action: FiniteTimeAction
    
    // MARK: - Private Methods
    
    var reverse: Bool = false {
        didSet {
            action.reverse = !action.reverse
        }
    }
    
    var duration: Double {
        return action.duration
    }
    
    func willBecomeActive() {
        action.willBecomeActive()
        onBecomeActive()
    }
    
    func didBecomeInactive() {
        action.didBecomeInactive()
        onBecomeInactive()
    }
    
    func willBegin() {
        action.willBegin()
    }
    
    func didFinish() {
        action.didFinish()
    }
    
    func update(t: CFTimeInterval) {
        action.update(t: 1 - t)
    }
}

extension FiniteTimeAction {
    func reversed() -> ReverseAction {
        return ReverseAction(action: self)
    }
}
