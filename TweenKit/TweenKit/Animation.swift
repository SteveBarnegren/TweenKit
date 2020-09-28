//
//  Animation.swift
//  TweenKit
//
//  Created by Steve Barnegren on 18/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

/**
 Actions added to the ActionScheduler are wrapped in an Animation Instance.
 You may wish to keep an Animation instance (it's returned when actions are run), so that you can stop the animation later.
 */
public class Animation : Equatable {
    
    // MARK: - Public
    
    /**
     Create an animation with the supplied action
     - Parameter action: The action to create the animation with
     */
    public init(action: SchedulableAction) {
        self.action = action
    }
    
    /**
     Closure to be called after each update
     */
    public var onDidUpdate: () -> () = {}
    
    // MARK: - Properties

    var hasDuration: Bool {
        return action is FiniteTimeAction
    }
    
    var duration: Double {
        
        guard let ftAction = action as? FiniteTimeAction else {
            return 0
        }
        
        return ftAction.duration
    }
    
    var elapsedTime: CFTimeInterval = 0
    
    private let action: SchedulableAction!
    
    // MARK: - Methods
    
    func willStart() {
        action.willBecomeActive()
        action.willBegin()
    }
    
    func didFinish() {
        action.didFinish()
        action.didBecomeInactive()
    }
    
    func update(elapsedTime: CFTimeInterval) { 
        
        self.elapsedTime = elapsedTime
        
        if let action = action as? FiniteTimeAction {
            let t = (elapsedTime / duration).orZeroIfNanOrInfinite
            action.update(t: t)
        }
        else if let action = action as? InfiniteTimeAction {
            action.update(elapsedTime: elapsedTime)
        }
        
        onDidUpdate()
    }
    
}

// MARK: - Equatable
public func ==(rhs: Animation, lhs: Animation) -> Bool {
    return rhs === lhs
}
