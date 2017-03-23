//
//  DelayAction.swift
//  TweenKit
//
//  Created by Steven Barnegren on 23/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

class DelayAction: FiniteTimeAction {
    
    // MARK: - Public
    
    init(duration: Double) {
        self.duration = duration
    }
    
    // MARK: - Properties
    
    let duration: Double
    var reverse = false
    
    var onBecomeActive: () -> () = {}
    var onBecomeInactive: () -> () = {}
    
    // MARK: - Methods
    
    func willBecomeActive() {
        onBecomeActive()
    }
    
    func didBecomeInactive() {
        onBecomeInactive()
    }
    
    func willBegin() {
    }
    
    func didFinish() {
    }
    
    func update(t: CFTimeInterval) {
    }
}
