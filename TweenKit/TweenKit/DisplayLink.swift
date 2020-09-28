//
//  DisplayLink.swift
//  TweenKit
//
//  Created by Steve Barnegren on 28/09/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation
import QuartzCore

#if os(macOS)
@objc class DisplayLink : NSObject {
    
    private let handler: (Double) -> ()
    private var timer: Timer?
    private var lastTimeStamp: Double?

    init(handler: @escaping (Double) -> ()) {
        self.handler = handler
        super.init()
        
        let timer = Timer(timeInterval: 0.001,
                          target: self,
                          selector: #selector(timerFired),
                          userInfo: nil,
                          repeats: true)
        
        RunLoop.current.add(timer, forMode: .common)
    }
    
    @objc private func timerFired(timer: Timer) {
        let currentTimeStamp = CACurrentMediaTime()
        guard let lastTimeStamp = self.lastTimeStamp else {
            self.lastTimeStamp = currentTimeStamp
            return
        }
        
        let dt = (currentTimeStamp - lastTimeStamp).constrained(min: 0)
        self.lastTimeStamp = currentTimeStamp
        self.handler(dt)
    }
    
    func invalidate() {
        timer?.invalidate()
    }
}
#else

import UIKit
@objc class DisplayLink : NSObject {
    
    var caDisplayLink: CADisplayLink? = nil
    private let handler: (Double) -> ()
    private var lastTimeStamp: Double?
    
    init(handler: @escaping (Double) -> ()) {
        
        self.handler = handler
        
        super.init()
        
        caDisplayLink = CADisplayLink(target: self,
                                      selector: #selector(displayLinkCallback(displaylink:)))
        
        caDisplayLink?.add(to: .current,
                           forMode: .common)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive),
                                               name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)

    }
    
    @objc private func displayLinkCallback(displaylink: CADisplayLink) {
        let timeStamp = displaylink.timestamp
        guard let lastTimeStamp = self.lastTimeStamp else {
            self.lastTimeStamp = timeStamp
            return
        }
        
        let dt = (timeStamp - lastTimeStamp).constrained(min: 0)
        self.lastTimeStamp = timeStamp
        
        self.handler(dt)
    }
    
    func invalidate() {
        caDisplayLink?.invalidate()
        lastTimeStamp = nil
    }
    
    @objc private func willResignActive() {
        caDisplayLink?.isPaused = true
        lastTimeStamp = nil
    }
    
    @objc private func didBecomeActive() {
        lastTimeStamp = nil
        caDisplayLink?.isPaused = false
    }
}
#endif
