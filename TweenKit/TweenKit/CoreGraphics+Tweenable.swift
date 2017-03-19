//
//  CoreGraphics+Tweenable.swift
//  TweenKit
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

extension CGPoint: Tweenable {
    public func lerp(t: Double, end: CGPoint) -> CGPoint {
        
        let xDiff = end.x - x
        let yDiff = end.y - y

        return CGPoint(x: x + (xDiff * CGFloat(t)),
                       y: y + (yDiff * CGFloat(t)))
    }
}

extension CGSize: Tweenable {
    public func lerp(t: Double, end: CGSize) -> CGSize {
        
        let widthDiff = end.width - width
        let heightDiff = end.height - height
        
        return CGSize(width: width + (widthDiff * CGFloat(t)),
                      height: height + (heightDiff * CGFloat(t)))
    }
}

