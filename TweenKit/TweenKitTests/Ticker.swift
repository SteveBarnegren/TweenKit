//
//  Ticker.swift
//  TweenKit
//
//  Created by Steven Barnegren on 20/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

/** Ticker is used to simulate the progression of time for tests */
class Ticker {
    
    var stepTime = 1.0/60.0
    let duration: Double
    let callback: (Double) -> ()
    
    init(duration: Double, callback: @escaping (_ dt: Double) -> ()) {
        
        self.duration = duration
        self.callback = callback
    }
    
    func run() {
        
        var remainingTime = duration
        
        while remainingTime - stepTime > 0 {
            callback(stepTime)
            remainingTime -= stepTime
        }
        
        callback(remainingTime)
    }
    
    
    
}
