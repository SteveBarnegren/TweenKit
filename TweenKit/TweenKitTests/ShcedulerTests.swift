//
//  ShedulerTests.swift
//  TweenKit
//
//  Created by Steven Barnegren on 20/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import TweenKit

class SchedulerTests: XCTestCase {
    
    var scheduler: Scheduler!
    
    override func setUp() {
        super.setUp()
        scheduler = Scheduler()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAnimationIsRemovedOnCompletion() {
        
        let duration = 5.0
        
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: duration) {_ in }
        let animation = Animation(action: action)
        scheduler.add(animation: animation)
        
        Ticker(duration: duration + 1) {
            self.scheduler.step(dt: $0)
        }.run()
        
        XCTAssertEqual(scheduler.numRunningAnimations, 0)
    }
}
