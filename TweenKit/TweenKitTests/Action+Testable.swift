//
//  Action+Testable.swift
//  TweenKit
//
//  Created by Steven Barnegren on 24/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation
import TweenKit

extension SchedulableAction {
    
    func simulateFullLifeCycle() {
        self.willBecomeActive()
        self.willBegin()
        self.didFinish()
        self.didBecomeInactive()
    }
}


