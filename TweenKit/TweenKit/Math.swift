//
//  Math.swift
//  TweenKit
//
//  Created by Steve Barnegren on 18/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

func vector2DDistance(v1: (x: Double, y: Double), v2: (x: Double, y: Double)) -> Double {
    
    let xDiff = v2.x - v1.x
    let yDiff = v2.y - v1.y
    
    return sqrt((xDiff * xDiff) + (yDiff * yDiff))
}

func max<T: Comparable>(_ values: T...) -> T {
    
    var maxValue = values.first!
    
    values.dropFirst().forEach{
        maxValue = max(maxValue, $0)
    }
    
    return maxValue
}

extension Comparable {
    
    func constrained(min: Self) -> Self {
        
        if self < min { return min }
        return self
    }

    func constrained(max: Self) -> Self {
        
        if self > max { return max }
        return self
    }

    func constrained(min: Self, max: Self) -> Self {
        
        if self < min { return min }
        if self > max { return max }
        return self
    }
}

extension Double {
    
    var fract: Double {
        return self - Double(Int(self))
    }
    
    var orZeroIfNanOrInfinite: Double {
        if self.isNaN || self.isInfinite {
            return 0
        } else {
            return self
        }
    }
}
