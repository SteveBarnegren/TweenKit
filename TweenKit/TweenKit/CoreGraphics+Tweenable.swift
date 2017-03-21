//
//  CoreGraphics+Tweenable.swift
//  TweenKit
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

extension CGFloat: Tweenable {
    public func lerp(t: Double, end: CGFloat) -> CGFloat {
        return self + (end - self) * CGFloat(t)
    }
    
    public func distanceTo(other: CGFloat) -> Double {
        return Double(other - self)
    }
}

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

