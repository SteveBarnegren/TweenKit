//
//  UIKit+Tweenable.swift
//  TweenKit
//
//  Created by Steve Barnegren on 19/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

#if canImport(UIKit)

import Foundation
import UIKit

extension UIColor: Tweenable {
    public func lerp(t: Double, end: UIColor) -> Self {
        
        var thisR: CGFloat = 0
        var thisG: CGFloat = 0
        var thisB: CGFloat = 0
        var thisA: CGFloat = 0
        
        getRed(&thisR, green: &thisG, blue: &thisB, alpha: &thisA)
        
        var endR: CGFloat = 0
        var endG: CGFloat = 0
        var endB: CGFloat = 0
        var endA: CGFloat = 0
        
        end.getRed(&endR, green: &endG, blue: &endB, alpha: &endA)
        
        return type(of: self).init(red: thisR + (endR - thisR) * CGFloat(t),
                                   green: thisG + (endG - thisG) * CGFloat(t),
                                   blue: thisB + (endB - thisB) * CGFloat(t),
                                   alpha: thisA + (endA - thisA) * CGFloat(t))
    }
    
    public func distanceTo(other: UIColor) -> Double {
        fatalError("Not implemented")
    }
}

#endif
