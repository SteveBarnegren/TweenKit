//
//  RepeatForeverAction.swift
//  TweenKit
//
//  Created by Steve Barnegren on 19/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public class RepeatForeverAction: InfiniteTimeAction, SchedulableAction {

    // MARK: - Public
    public init(action: FiniteTimeAction) {
        self.action = action;
    }
    
    // MARK: - Private Properties
    let action: FiniteTimeAction

    // MARK: - Private Methods
    
    public func update(elapsedTime: CFTimeInterval) {
        let actionT = (elapsedTime / action.duration).fract
        action.update(t: actionT)
    }
}

public extension FiniteTimeAction {
    
    public func repeatedForever() -> RepeatForeverAction {
        return RepeatForeverAction(action: self)
    }
}
