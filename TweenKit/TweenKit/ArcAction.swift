//
//  ArcAction.swift
//  TweenKit
//
//  Created by Steven Barnegren on 22/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public class ArcAction<T: Tweenable2DCoordinate>: FiniteTimeAction {
    
    // MARK: - Public
    
    public init(center: T,
                radius: Double,
                startRadians: Double,
                endRadians: Double,
                duration: Double,
                update: @escaping (T) -> ()) {
        
        self.center = center
        self.radius = radius
        self.startAngle = startRadians
        self.endAngle = endRadians
        self.duration = duration
        self.handler = update
    }
    
    public init(center: T,
                radius: Double,
                startDegrees: Double,
                endDegrees: Double,
                duration: Double,
                update: @escaping (T) -> ()) {
        
        self.center = center
        self.radius = radius
        self.startAngle = startDegrees * (M_PI / 180.0)
        self.endAngle = endDegrees * (M_PI / 180.0)
        self.duration = duration
        self.handler = update
    }

    
    public var onBecomeActive: () -> () = {}
    public var onBecomeInactive: () -> () = {}
    public var easing = Easing.linear

    // MARK: - Properties
    
    let center: T
    let radius: Double
    let startAngle: Double
    let endAngle: Double
    public let duration: Double
    public var reverse = false
    let handler: (T) -> ()
    
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
    }
    
    public func update(t: CFTimeInterval) {
        
        var t = t
        t = easing.apply(t: t)
        
        let angle = startAngle + (endAngle - startAngle)*t
        
        let xFromCenter = sin(angle) * radius
        let yFromCenter = cos(angle) * radius

        let x = center.tweenableX + xFromCenter
        let y = center.tweenableY - yFromCenter
        
        let newValue = T(tweenableX: x, y: y)
        
        handler(newValue)
    }

}

