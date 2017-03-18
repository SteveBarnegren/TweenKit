//
//  Math.swift
//  TweenKit
//
//  Created by Steve Barnegren on 18/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

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
