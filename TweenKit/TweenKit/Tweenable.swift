//
//  Tweenable.swift
//  TweenKit
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

// MARK: - Tweenable

public protocol Tweenable {
    func lerp(t: Double, end: Self) -> Self
    func distanceTo(other: Self) -> Double
}

extension Float: Tweenable {
    public func lerp(t: Double, end: Float) -> Float {
        return self + (end - self) * Float(t)
    }
    
    public func distanceTo(other: Float) -> Double {
        return Double(other - self)
    }
}

extension Double: Tweenable {
    public func lerp(t: Double, end: Double) -> Double {
        return self + (end - self) * t
    }
    
    public func distanceTo(other: Double) -> Double {
        return other - self
    }
}

// MARK: - Tweenable2D

public protocol Tweenable2DCoordinate{
    var tweenableX: Double {get}
    var tweenableY: Double {get}
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
