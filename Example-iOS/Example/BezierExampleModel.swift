//
//  BezierExampleModel.swift
//  Example
//
//  Created by Steven Barnegren on 30/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation
import UIKit

protocol BezierDemoModel {
    
    // The number of points that the curve should have
    var numberOfPoints: Int {get}
    
    // Straight-line connects that should be drawn between points (eg. to show handles)
    var connections: [(Int, Int)] {get}
    
    // The start position for each point
    func startPositionForPoint(atIndex index: Int) -> CGPoint
    
    // Make a bezier path from points
    func makePath(fromPoints points: [CGPoint]) -> UIBezierPath
}

struct QuadCurveDemoModel: BezierDemoModel {
    
    // 0. Start
    // 1. control
    // 2. end
    
    var numberOfPoints: Int {
        return 3
    }
    
    func startPositionForPoint(atIndex index: Int) -> CGPoint {
        
        let sideMargin = CGFloat(70.0)
        
        switch index {
        case 0:
            return CGPoint(x: sideMargin,
                           y: UIScreen.main.bounds.size.height/2)
        case 1:
            return CGPoint(x: UIScreen.main.bounds.size.width/2,
                           y: UIScreen.main.bounds.size.height/2 - 100)
        case 2:
            return CGPoint(x: UIScreen.main.bounds.size.width - sideMargin,
                           y: UIScreen.main.bounds.size.height/2)
        default:
            fatalError()
        }
    }
    
    func makePath(fromPoints points: [CGPoint]) -> UIBezierPath {
        
        let start = points[0]
        let control = points[1]
        let end = points[2]
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addQuadCurve(to: end, controlPoint: control)
        return path
    }
    
    var connections: [(Int, Int)] {
        return []
    }
}

struct CubicCurveDemoModel: BezierDemoModel {
    
    // 0. Start
    // 1. control1
    // 2. control2
    // 3. end
    
    var numberOfPoints: Int {
        return 4
    }
    
    func startPositionForPoint(atIndex index: Int) -> CGPoint {
        
        let sideMargin = CGFloat(70.0)
        let controlOffsetY = CGFloat(100.0)
        let horizontalLength = UIScreen.main.bounds.size.width - (sideMargin*2)
        
        switch index {
        case 0:
            return CGPoint(x: sideMargin,
                           y: UIScreen.main.bounds.size.height/2)
        case 1:
            return CGPoint(x: sideMargin + (horizontalLength/3),
                           y: UIScreen.main.bounds.size.height/2 + controlOffsetY)
        case 2:
            return CGPoint(x: sideMargin + (horizontalLength/3*2),
                           y: UIScreen.main.bounds.size.height/2 - controlOffsetY)
        case 3:
            return CGPoint(x: sideMargin + horizontalLength,
                           y: UIScreen.main.bounds.size.height/2)
        default:
            fatalError()
        }
    }
    
    func makePath(fromPoints points: [CGPoint]) -> UIBezierPath {
        
        let start = points[0]
        let cp1 = points[1]
        let cp2 = points[2]
        let end = points[3]
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        return path
    }
        
    var connections: [(Int, Int)] {
        return [(0, 1), (3, 2)]
    }
}
