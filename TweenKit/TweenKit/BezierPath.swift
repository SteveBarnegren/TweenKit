//
//  BezierPath.swift
//  TweenKit
//
//  Created by Steven Barnegren on 28/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

// MARK: - ****** CURVE ******

/** Enum for describing a curve segment for BezierPath */
public enum Curve<T: Tweenable2DCoordinate> {
    case lineToPoint(T)
    case quadCurveToPoint(T, cp: T)
    case cubicCurveToPoint(T, cp1: T, cp2: T)
    
    var endPoint: T {
        switch self {
        case let .lineToPoint(p): return p
        case let .quadCurveToPoint(p, _): return p
        case let .cubicCurveToPoint(p, _, _): return p
        }
    }
    
    func length(from: T) -> Double {
        
        /*
         We have to split the curves in to segments to estimate the distance.
         For the moment just split in to 20, which is high enough resolution for the majority of curves,
         but we could get away with much less for short curves
         might have to think of a better way to approach this
         */
        
        let numSegments = 20
        
        var distance = 0.0
        var lastPoint = from
        
        for i in 1...numSegments {
            
            let t = Double(i) / Double(numSegments)
            let currentPoint = value(previous: from, t: t)
            
            distance += vector2DDistance(v1: (x: lastPoint.tweenableX, y: lastPoint.tweenableY),
                                         v2: (x: currentPoint.tweenableX, y: currentPoint.tweenableY))
            lastPoint = currentPoint
        }
        
        return distance
    }
    
    // MARK: - Get value at t
    
    func value(previous: T, t: Double) -> T {
        
        switch self {
        case let .lineToPoint(end):
            return valueOnLineToPoint(from: previous, to: end, t: t)
        case let .quadCurveToPoint(end, control):
            return valueOnQuadCurveToPoint(from: previous, to: end, cp: control, t: t)
        case let .cubicCurveToPoint(end, control1, control2):
            return valueOnCubicCurveToPoint(from: previous, to: end, cp1: control1, cp2: control2, t: t)
        }
    }
    
    func valueOnLineToPoint(from: T, to: T, t: Double) -> T {
        let x = from.tweenableX + ((to.tweenableX - from.tweenableX) * t)
        let y = from.tweenableY + ((to.tweenableY - from.tweenableY) * t)
        return T(tweenableX: x, y: y)
    }
    
    func valueOnQuadCurveToPoint(from: T, to: T, cp: T, t: Double) -> T {
        
        let x = (1 - t) * (1 - t) * from.tweenableX + 2 * (1 - t) * t * cp.tweenableX + t * t * to.tweenableX;
        let y = (1 - t) * (1 - t) * from.tweenableY + 2 * (1 - t) * t * cp.tweenableY + t * t * to.tweenableY;
        return T(tweenableX: x, y: y)
    }
    
    func valueOnCubicCurveToPoint(from: T, to: T, cp1: T, cp2: T, t: Double) -> T {
        
        let x = pow(1 - t, 3) * from.tweenableX + 3.0 * pow(1 - t, 2) * t * cp1.tweenableX + 3.0 * (1 - t) * t * t * cp2.tweenableX + t * t * t * to.tweenableX;
        let y = pow(1 - t, 3) * from.tweenableY + 3.0 * pow(1 - t, 2) * t * cp1.tweenableY + 3.0 * (1 - t) * t * t * cp2.tweenableY + t * t * t * to.tweenableY;
        
        return T(tweenableX: x, y: y)
    }
}

// MARK: - ****** BEZIER POINT ******

struct BezierPoint<T: Tweenable2DCoordinate> {
    let curve: Curve<T>
    var length: Double = 0.0
    var pathPctAtStart = 0.0
    var pathPctAtEnd = 0.0
    
    init(curve: Curve<T>) {
        self.curve = curve
    }
}


// MARK: - ****** BEZIER PATH ******

/** BezierPaths can be passed to BezierAction to animate over curves/paths */
public struct BezierPath<T: Tweenable2DCoordinate> {
    let startLocation: T
    let endLocation: T
    var points = [BezierPoint<T>]()
    var length = 0.0
    var startOvershootAngle = 0.0
    var endOvershootAngle = 0.0
    
    /**
     Create bezier path instance from curves
     - Parameter start: The start coordinate of the curve
     - Parameter curves: Array of curves that make up the path
     */
    public init(start: T, curves: [Curve<T>]) {
        
        guard curves.count > 0 else {
            fatalError("Bezier path cannot be constructed with just a start point")
        }
        
        self.points = curves.map{
            BezierPoint(curve: $0)
        }
        
        self.startLocation = start
        self.endLocation = points.last!.curve.endPoint

        calculatePointLengths()
        calculatePathLength()
        calculatePointPathPcts()
        calculateOvershootAngles()
    }
    
    /** Calculates the length to each point. This is slow, so it is calculated once and the result is stored in the point struct */
    mutating func calculatePointLengths() {
        
        var lastPoint = startLocation
        
        for i in 0..<points.count{
            let length = points[i].curve.length(from: lastPoint)
            points[i].length = length
            lastPoint = points[i].curve.endPoint
        }
    }
    
    /** Calculates the whole path length, this isn't super fast for long paths, so it gets stored */
    mutating func calculatePathLength() {
        
        var cumulativeLength = 0.0
        points.forEach{
            cumulativeLength += $0.length
        }
        length = cumulativeLength
    }
    
    /** Calculates and stores the pct along the path that each point begins */
    mutating func calculatePointPathPcts() {
        
        var cumulativeLength = 0.0
        
        for i in 0..<points.count{
            
            points[i].pathPctAtStart = (i == 0 ? 0 : cumulativeLength / length)
            cumulativeLength += points[i].length
            points[i].pathPctAtEnd = (i == points.count - 1 ? 1.0 : cumulativeLength / length)
        }
    }
    
    /** Calculates the overshoot angles (the angles we should use to extend the path is t < 0 || t > 1) */
    mutating func calculateOvershootAngles() {
        
        func angle(from: T, to: T) -> Double {
            return from.angle(to: to)
        }
        
        let firstCurve = points.first!.curve
        startOvershootAngle = angle(from: firstCurve.value(previous: startLocation, t: 0.001),
                                    to: firstCurve.value(previous: startLocation, t: 0))
        
        let lastCurve = points.last!.curve
        let previousLocation = (points.count > 1) ? points[points.count - 2].curve.endPoint : startLocation
        endOvershootAngle = angle(from: lastCurve.value(previous: previousLocation, t: 0.999),
                                    to: lastCurve.value(previous: previousLocation, t: 1.0))
    }
    
    /** Get the value at a point on the path */
    func valueAt(t: Double) -> T {
        
        // If t is not in 0-1 range, calculate the overshoot
        if t < 0 {
            return valueAtStartOvershoot(pct: abs(t))
        }
        
        if t > 1 {
            return valueAtEndOvershoot(pct: t - 1)
        }
        
        // Get the current point
        var lastLocation = startLocation
        var point = points.first!
        
        for (index, p) in points.enumerated() {
            
            var next: BezierPoint<T>?
            if index + 1 < points.count {
                next = points[index + 1]
            }
            
            if index == points.count-1 {
                point = p
                break
            }
            else if let next = next, next.pathPctAtStart > t {
                point = p
                break
            }
            else{
                lastLocation = p.curve.endPoint
            }
        }
        
        // Get the value from the point
        let pointTLength = point.pathPctAtEnd - point.pathPctAtStart
        var pointT = (t - point.pathPctAtStart) / pointTLength
        pointT = pointT.constrained(min: 0.0, max: 1.0)
        return point.curve.value(previous: lastLocation, t: pointT)
    }
    
    func valueAtStartOvershoot(pct: Double) -> T {
        
        let overshootLength = length * pct
        let x = cos(startOvershootAngle) * overshootLength
        let y = sin(startOvershootAngle) * overshootLength
        
        return T(tweenableX: startLocation.tweenableX + x,
                 y: startLocation.tweenableY + y)
    }
    
    func valueAtEndOvershoot(pct: Double) -> T {
        
        let overshootLength = length * pct
        let x = cos(endOvershootAngle) * overshootLength
        let y = sin(endOvershootAngle) * overshootLength
        
        return T(tweenableX: endLocation.tweenableX + x,
                 y: endLocation.tweenableY + y)
    }
}
