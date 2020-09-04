//
//  BezierPath+Testable.swift
//  TweenKit
//
//  Created by Steven Barnegren on 28/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

#if canImport(UIKit)

import Foundation
import UIKit
@testable import TweenKit

func makeBasicTestPath() -> BezierPath<CGPoint> {
   
    let startPoint = CGPoint(x: 50, y: 50)
    let endPoint = CGPoint(x: 100, y: 100)
    
    let path = BezierPath(start: startPoint,
                          curves: [.lineToPoint(endPoint)])
    return path
}

#endif
