//
//  InterpolateActionTests.swift
//  TweenKit
//
//  Created by Steven Barnegren on 20/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import TweenKit

class InterpolateActionTests: XCTestCase {
    
    var scheduler: Scheduler!
    
    override func setUp() {
        super.setUp()
        scheduler = Scheduler()
    }
    
    func testInterpolateActionEndsWithEndValue() {
        
        let duration = 0.1
        let expectedEndValue = 12.0
        
        var value = 0.0
        let action = InterpolationAction(from: 0.0, to: expectedEndValue, duration: duration) {
            value = $0
        }
        let animation = Animation(action: action)
        scheduler.add(animation: animation)
        scheduler.progressTime(duration: duration + 0.1)
        
        XCTAssertEqualWithAccuracy(value, expectedEndValue, accuracy: 0.001)
    }
    
    func testInterpolateActionEndWithStartValueWhenInReverseAction() {
        
        let duration = 0.1
        
        var value = 0.0
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: duration) { value = $0 }
        let reversed = action.reversed()
        
        let animation = Animation(action: reversed)
        scheduler.add(animation: animation)
        scheduler.progressTime(duration: duration + 0.1)
        
        XCTAssertEqualWithAccuracy(value, 0.0, accuracy: 0.001)
    }
    
}
