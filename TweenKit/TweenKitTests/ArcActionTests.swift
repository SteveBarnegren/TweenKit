//
//  ArcActionTests.swift
//  TweenKit
//
//  Created by Steven Barnegren on 27/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import TweenKit

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

class ArcActionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testArcActionProducesExpectedStartAndEndValues() {
        
        var value = CGPoint.zero
        
        let center = CGPoint(x: 100, y: 100)
        let radius = 50.0
        
        // Create and start the action
        let action = ArcAction(center: center,
                               radius: radius,
                               startDegrees: 0.0,
                               endDegrees: 90.0,
                               duration: 5.0,
                               update: { value = $0 })
        
        action.willBecomeActive()
        action.willBegin()
        
        // Test start value
        action.update(t: 0.0)
        let expectedStartValue = CGPoint(x: center.x,
                                         y: center.y - CGFloat(radius))
        
        AssertCGPointsAreEqualWithAccuracy(value, expectedStartValue, accuracy: 0.001)
        
        // Test end value
        action.update(t: 1.0)
        let expectedEndValue = CGPoint(x: center.x + CGFloat(radius),
                                       y: center.y)
        
        AssertCGPointsAreEqualWithAccuracy(value, expectedEndValue, accuracy: 0.001)
    }
    
    func testArcActionLifeCycleEventsUpdateValue() {
        
        var value = CGPoint.zero
        
        let center = CGPoint(x: 100, y: 100)
        let radius = 50.0
        
        let action = ArcAction(center: center,
                               radius: radius,
                               startDegrees: 0.0,
                               endDegrees: 90.0,
                               duration: 5.0,
                               update: { value = $0 })
        
        action.simulateFullLifeCycle()
        
        let expectedValue = CGPoint(x: center.x + CGFloat(radius),
                                    y: center.y)
        
        AssertCGPointsAreEqualWithAccuracy(value, expectedValue, accuracy: 0.001)
    }
}
