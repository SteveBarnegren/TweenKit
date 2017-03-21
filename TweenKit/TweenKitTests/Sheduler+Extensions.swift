//
//  Sheduler+Extensions.swift
//  TweenKit
//
//  Created by Steven Barnegren on 20/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation
@testable import TweenKit

extension Scheduler {
    
    func progressTime(duration: Double, stepSize: Double = 1.0/60.0) {
        Ticker(duration: duration) {
            self.step(dt: $0)
            }.run()
    }
}
