//
//  InterpolateAction.swift
//  TweenKit
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public enum TweenableValue<T: Tweenable> {
    case constant(T)
    case dynamic( () -> (T) )
    
    internal func getValue() -> T {
        switch self {
        case .constant(let value):
            return value
        case .dynamic(let closure):
            return closure()
        }
    }
}

public class InterpolationAction<T: Tweenable>: FiniteTimeAction, SchedulableAction {

    // MARK: - Public

    public var onBecomeActive: () -> () = {}
    public var onBecomeInactive: () -> () = {}
    public var easing = Easing.linear
    
    public init(from startValue: T,
                to endValue: T,
                duration: Double,
                update: @escaping (_: T) -> ()) {
        
        self.duration = duration
        self.updateHandler = update
        
        self.startTweenableValue = .constant(startValue)
        self.endTweenableValue = .constant(endValue)
    }
    
    public init(from startValue: @escaping () -> (T),
                to endValue: T,
                duration: Double,
                update: @escaping (_: T) -> ()) {
        
        self.duration = duration
        self.updateHandler = update
        
        self.startTweenableValue = .dynamic(startValue)
        self.endTweenableValue = .constant(endValue)
    }
    
    public init(from startValue: T,
                to endValue: T,
                speed: Double,
                update: @escaping (_: T) -> ()) {
        
        self.duration = startValue.distanceTo(other: endValue) / speed
        self.updateHandler = update
        self.startTweenableValue = .constant(startValue)
        self.endTweenableValue = .constant(endValue)
    }
    
    // MARK: - Properties
    
    private var startTweenableValue: TweenableValue<T>
    private var endTweenableValue: TweenableValue<T>

    public var startValue: T! // Make private - set in initialiser
    public var endValue: T! // Make private - set in initialiser
    
    public var duration = Double(0)
    public var reverse = false
    
    var updateHandler: (_: T) -> () = {_ in}

    // MARK: - Methods
    
    public func willBecomeActive() {
        
        if startValue == nil {
            startValue = startTweenableValue.getValue()
        }
        
        if endValue == nil {
            endValue = endTweenableValue.getValue()
        }
        
        onBecomeActive()
    }
    
    public func didBecomeInactive() {
        onBecomeInactive()
    }
    
    public func willBegin() {
    }
    
    public func didFinish() {
    }
    
    public func update(t: Double) {
        
        // Apply easing
        var t = t
        t = easing.apply(t: t)
        
        // Calculate value
        let newValue = startValue.lerp(t: t, end: endValue)
        
        // Call the update handler
        updateHandler(newValue)
    }
    
}
 

