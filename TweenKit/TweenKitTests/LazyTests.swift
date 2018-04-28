//
//  LazyTests.swift
//  TweenKitTests
//
//  Created by Steve Barnegren on 28/04/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import TweenKit

class LazyTests: XCTestCase {
    
    func testLazyType() {
        
        var numberOfCalculations = 0
        
        let lazyInt = Lazy<Int> { () -> Int in
            numberOfCalculations += 1
            return 5
        }
        
        // Unused
        XCTAssertEqual(numberOfCalculations, 0)
        
        // Caclulate initial value
        XCTAssertEqual(lazyInt.value, 5)
        XCTAssertEqual(numberOfCalculations, 1)
        
        // Access cached value
        XCTAssertEqual(lazyInt.value, 5)
        XCTAssertEqual(numberOfCalculations, 1)
    }
}
