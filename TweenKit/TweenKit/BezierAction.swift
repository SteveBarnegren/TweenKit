//
//  BezierAction.swift
//  TweenKit
//
//  Created by Steven Barnegren on 27/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

/** Action for animating over a bezier path */
public class BezierAction<T: Tweenable2DCoordinate>: FiniteTimeAction {
    
    // MARK: - Public
    
    /**
     Create with a BezierPath instance
     - Parameter path: The path to animate over
     - Parameter duration: Duration of the animation
     - Parameter update: Callback with position and rotation
     */
    public init(path: BezierPath<T>, duration: Double, update: @escaping (T, Lazy<Double>) -> ()) {
        self.duration = duration
        self.path = path
        self.updateHandler = update
    }
    
    public var easing = Easing.linear
    public var duration: Double
    public var reverse = false

    public var onBecomeActive: () -> () = {}
    public var onBecomeInactive: () -> () = {}
    
    // MARK: - Properties
    
    let path: BezierPath<T>
    let updateHandler: (T, Lazy<Double>) -> ()
    
    // MARK: - Methods
    
    public func willBecomeActive() {
        onBecomeActive()
    }
    
    public func didBecomeInactive() {
        onBecomeInactive()
    }
    
    public func willBegin() {
    }
    
    public func didFinish() {
        update(t: reverse ? 0.0 : 1.0)
    }
    
    public func update(t: CFTimeInterval) {
        
        let t = easing.apply(t: t)
        
        let value = path.valueAt(t: t)
        
        let rotation = Lazy<Double> {
            [unowned self] in
            
            let diff = 0.001
            
            let beforeValue = self.path.valueAt(t: t - diff)
            let afterValue = self.path.valueAt(t: t + diff)
            return beforeValue.angle(to: afterValue)
        }
        
        updateHandler(value, rotation)
    }
}
