//
//  RepeatForeverAction.swift
//  TweenKit
//
//  Created by Steve Barnegren on 19/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public class RepeatForeverAction: SchedulableAction {

    // MARK: - Public
    public init(action: SchedulableAction) {
        self.action = action;
    }
    
    var finiteDuration: CFTimeInterval {
        return self.action.finiteDuration
    }
    
    // MARK: - Private Properties
    public let duration = ActionDuration.infinite
    public var reverse = false // reverse state is ignored
    let action: SchedulableAction

    // MARK: - Private Methods
    
    public func updateWithTime(t: CFTimeInterval) {
        action.updateWithTime(t: t.fract)
    }
    
}


public extension SchedulableAction {
    
    public func repeatedForever() -> RepeatForeverAction {
        return RepeatForeverAction(action: self)
    }
}
