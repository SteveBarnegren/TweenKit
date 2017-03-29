//
//  BezierAction.swift
//  TweenKit
//
//  Created by Steven Barnegren on 27/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public class BezierAction<T: Tweenable2DCoordinate>: FiniteTimeAction {
    
    // MARK: - Public
    public init(path: BezierPath<T>, duration: Double, update: @escaping (T) -> ()) {
        self.duration = duration
        self.path = path
        self.updateHandler = update
    }
    
    public var easing = Easing.elasticInOut
    public var duration: Double
    public var reverse = false

    public var onBecomeActive: () -> () = {}
    public var onBecomeInactive: () -> () = {}
    
    // MARK: - Properties
    
    let path: BezierPath<T>
    let updateHandler: (T) -> ()
    
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
        updateHandler(value)
    }
}
