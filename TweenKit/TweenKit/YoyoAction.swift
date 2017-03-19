//
//  YoyoAction.swift
//  TweenKit
//
//  Created by Steve Barnegren on 19/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public class YoyoAction: SchedulableAction {
    
    // MARK: - Public
    
    public var reverse = false

    public init(action: SchedulableAction) {
        self.action = action
        self.duration = .finite( action.finiteDuration * 2 )
    }
    
    // MARK: - Private Properties
    
    public internal(set) var duration: ActionDuration
    let action: SchedulableAction
    
    // MARK: - Private Methods
    
    public func updateWithTime(t: CFTimeInterval) {
        
        if t < 0.5 {
            action.reverse = false
            let actionT = t * 2
            action.updateWithTime(t: actionT)
        }
        else{
            action.reverse = true
            let actionT = 1-((t - 0.5) * 2);
            action.updateWithTime(t: actionT)
        }
    }
}

public extension SchedulableAction {
    
    public func yoyo() -> YoyoAction {
        return YoyoAction(action: self)
    }
}
