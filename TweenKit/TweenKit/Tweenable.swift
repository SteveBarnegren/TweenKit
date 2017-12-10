//
//  Tweenable.swift
//  TweenKit
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

// MARK: - Tweenable

/** Protocol for a value that can be animated by TweenKit */
public protocol Tweenable {
    
    /**
     Called by TweenKit to generate a value between self and an end value at a certain t (0-1)
     - Parameter t: The time between the current value (self) and the end value (end)
     - Parameter end: The end value
     - Returns: Interpolated value between self and end
     */
    func lerp(t: Double, end: Self) -> Self
    
    /**
     Returns the absolute distance to another value. Required to calculate durations for speed based actions.
     If you don't need to use speed based actions, you can fatal error here
     - Parameter other: Another instance
     - Returns: The distance to the other instance, must be positive
     */
    func distanceTo(other: Self) -> Double
}

extension Float: Tweenable {
    public func lerp(t: Double, end: Float) -> Float {
        return self + (end - self) * Float(t)
    }
    
    public func distanceTo(other: Float) -> Double {
        return Double(abs(other - self))
    }
}

extension Double: Tweenable {
    public func lerp(t: Double, end: Double) -> Double {
        return self + (end - self) * t
    }
    
    public func distanceTo(other: Double) -> Double {
        return abs(other - self)
    }
}

// MARK: - Tweenable2D

/** Protocal for values that can be animated with a separate x and y value */
public protocol Tweenable2DCoordinate{
    
    /** Get the current x value */
    var tweenableX: Double {get}
    
    /** Get the current y value */
    var tweenableY: Double {get}
    
    /** Create a new value from and x and y value */
    init(tweenableX x: Double, y: Double)
}

extension Tweenable2DCoordinate {
    
    func angle(to other: Self) -> Double {
        
        let adj = other.tweenableX - self.tweenableX
        let opp = other.tweenableY - self.tweenableY
        var angle = atan(opp/adj)
        
        if other.tweenableX > self.tweenableX {
            angle += Double.pi
        }
        
        return angle + Double.pi
    }
}
