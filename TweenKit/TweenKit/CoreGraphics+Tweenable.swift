//
//  CoreGraphics+Tweenable.swift
//  TweenKit
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation
import CoreGraphics

// MARK: - CGFloat

extension CGFloat: Tweenable {
    public func lerp(t: Double, end: CGFloat) -> CGFloat {
        return self + (end - self) * CGFloat(t)
    }
    
    public func distanceTo(other: CGFloat) -> Double {
        return Double(abs(other - self))
    }
}

// MARK: - CGPoint

extension CGPoint: Tweenable {
    public func lerp(t: Double, end: CGPoint) -> CGPoint {
        
        let xDiff = end.x - x
        let yDiff = end.y - y

        return CGPoint(x: x + (xDiff * CGFloat(t)),
                       y: y + (yDiff * CGFloat(t)))
    }
    
    public func distanceTo(other: CGPoint) -> Double {
        return vector2DDistance(v1: (Double(self.x), Double(self.y)),
                                v2: (Double(other.x), Double(other.y)))
    }
}

extension CGPoint: Tweenable2DCoordinate {
    
    public var tweenableX: Double {
        return Double(self.x)
    }
    
    public var tweenableY: Double {
        return Double(self.y)
    }
    
    public init(tweenableX x: Double, y: Double) {
        self.init(x: x, y: y)
    }
}

// MARK: - CGSize

extension CGSize: Tweenable {
    public func lerp(t: Double, end: CGSize) -> CGSize {
        
        let widthDiff = end.width - width
        let heightDiff = end.height - height
        
        return CGSize(width: width + (widthDiff * CGFloat(t)),
                      height: height + (heightDiff * CGFloat(t)))
    }
    
    public func distanceTo(other: CGSize) -> Double {
        return vector2DDistance(v1: (Double(self.width), Double(self.height)),
                                v2: (Double(other.width), Double(other.height)))
    }
}

// MARK: - CGRect

extension CGRect: Tweenable {
    
    public func lerp(t: Double, end: CGRect) -> CGRect {
        
        return CGRect(x: self.origin.x + (end.origin.x - self.origin.x) * CGFloat(t),
                      y: self.origin.y + (end.origin.y - self.origin.y) * CGFloat(t),
                      width: self.size.width + (end.size.width - self.size.width) * CGFloat(t),
                      height: self.size.height + (end.size.height - self.size.height) * CGFloat(t))
    }
    
    public func distanceTo(other: CGRect) -> Double {
        fatalError("Not implemented")
    }
}

