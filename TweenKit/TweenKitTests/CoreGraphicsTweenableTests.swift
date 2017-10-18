//
//  CoreGraphicsTweenableTests.swift
//  TweenKit
//
//  Created by Steven Barnegren on 06/04/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import TweenKit

class CoreGraphicsTweenableTests: XCTestCase {
    
    // MARK: - CGFloat
    
    func testCGFloatLerpResultsInCorrectValue() {
    
        let start = CGFloat(2)
        let end = CGFloat(4)
        XCTAssertEqual(start.lerp(t: 0.5, end: end), CGFloat(3), accuracy: 0.001)
    }
    
    // MARK: - CGPoint
    
    func testCGPointLerpResultsInCorrectValue() {
        
        let start = CGPoint(x: 2, y: 2)
        let end = CGPoint(x: 4, y: 4)
        AssertCGPointsAreEqualWithAccuracy(start.lerp(t: 0.5, end: end),
                                           CGPoint(x: 3, y: 3),
                                           accuracy: 0.001)
    }
    
    func testCGPointCanBeConstructedAsTweenable2DCoordinate() {
    
        let x = CGFloat(2)
        let y = CGFloat(3)
        
        let normal = CGPoint(x: x, y: y)
        let tweenable = CGPoint(tweenableX: Double(x), y: Double(y))

        AssertCGPointsAreEqualWithAccuracy(normal, tweenable, accuracy: 0.001)
    }
    
    func testCGPointReturnsCorrectXAndYAsTweenableCoordinate() {
        
        let x = CGFloat(2)
        let y = CGFloat(5)
        
        let point = CGPoint(x: x, y: y)
       
        XCTAssertEqual(point.tweenableX, Double(x), accuracy: 0.001)
        XCTAssertEqual(point.tweenableY, Double(y), accuracy: 0.001)
    }
    
    // MARK: - CGSize
    
    func testCGSizeLerpResultsInCorrectValue() {
        
        let start = CGSize(width: 2, height: 10)
        let end = CGSize(width: 4, height: 20)
        
        let result = start.lerp(t: 0.5, end: end)
        let expected = CGSize(width: 3, height: 15)
        
        AssertCGSizesAreEqualWithAccuracy(result, expected, accuracy: 0.001)
    }
    
    // MARK: - CGRect
    
    func testCGRectLerpResultsInCorrectValue() {
        
        let start = CGRect(x: 10, y: 20, width: 30, height: 40)
        let end = CGRect(x: 20, y: 30, width: 40, height: 50)

        let result = start.lerp(t: 0.5, end: end)
        let expected = CGRect(x: 15, y: 25, width: 35, height: 45)
        
        AssertCGRectsAreEqualWithAccuracy(result, expected, accuracy: 0.001)
    }
    
}
