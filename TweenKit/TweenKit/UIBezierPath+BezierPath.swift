//
//  UIBezierPath+BezierPath.swift
//  TweenKit
//
//  Created by Steven Barnegren on 28/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGPath {
    
    /**
     The path as a TweenKit.BezierPath instance
     - Returns: A TweenKit.BezierPath instance
     */
    func asBezierPath() -> BezierPath<CGPoint> {
        
        // Define Path Element
        struct PathElement {
            var startPoint : CGPoint?
            var curve: Curve<CGPoint>?
            
            init(startPoint: CGPoint) {
                self.startPoint = startPoint
                self.curve = nil
            }
            
            init(curve: Curve<CGPoint>) {
                self.curve = curve
                self.startPoint = nil
            }
        }
        
        // Get Path elements
        var pathElements = [PathElement]()
        
        withUnsafeMutablePointer(to: &pathElements) { elementsPointer in
            
            let rawElementsPointer = UnsafeMutableRawPointer(elementsPointer)
            
            self.apply(info: rawElementsPointer) { userInfo, nextElementPointer in
                
                let element = nextElementPointer.pointee
                let pathElements = userInfo?.assumingMemoryBound(to: [PathElement].self)
                
                func getStartPoint() -> CGPoint? {
                    for p in (pathElements?.pointee)! {
                        if let start = p.startPoint {
                            return start
                        }
                    }
                    return nil
                }
                
                var newPathElement: PathElement?
                
                switch element.type {
                case .moveToPoint:
                    guard getStartPoint() == nil else { fatalError("Paths must be continuous") }
                    let points = Array(UnsafeBufferPointer(start: element.points, count: 1))
                    newPathElement = PathElement(startPoint: points[0])
                    
                case .addLineToPoint:
                    let points = Array(UnsafeBufferPointer(start: element.points, count: 1))
                    newPathElement = PathElement(curve: .lineToPoint(points[0]))
                    
                case .addQuadCurveToPoint:
                    let points = Array(UnsafeBufferPointer(start: element.points, count: 2))
                    newPathElement = PathElement(curve: .quadCurveToPoint(points[1], cp: points[0]))
                    
                case .addCurveToPoint:
                    let points = Array(UnsafeBufferPointer(start: element.points, count: 3))
                    newPathElement = PathElement(curve: .cubicCurveToPoint(points[2], cp1: points[0], cp2: points[1]))
                    
                case .closeSubpath:
                    guard let start = getStartPoint() else {
                        fatalError("Cannot close a path that has not started")
                    }
                    newPathElement = PathElement(curve: .lineToPoint(start))
                @unknown default:
                    print("Unsupported CGPathElementType")
                    break
                }
                
                guard let newPath = newPathElement else { return }
                
                pathElements?.pointee.append(newPath)
            }
        }
        
        // Convert to Bezier Path
        var startPoint: CGPoint?
        var curves = [Curve<CGPoint>]()
        
        for pathElement in pathElements {
            
            if let curve = pathElement.curve {
                curves.append(curve)
            }
            else if let start = pathElement.startPoint {
                startPoint = start
            }
        }
        
        guard let start = startPoint else {
            fatalError("Cannot create a path without a start point")
        }
        
        return BezierPath(start: start, curves: curves)
    }
}

#if canImport(UIKit)
import UIKit

public extension UIBezierPath {
    
    /**
     The path as a TweenKit.BezierPath instance
     - Returns: A TweenKit.BezierPath instance
     */
    func asBezierPath() -> BezierPath<CGPoint> {
        return self.cgPath.asBezierPath()
    }
}
#endif
