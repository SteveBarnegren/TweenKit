//
//  ViewController.swift
//  Example-macOS
//
//  Created by Steve Barnegren on 04/09/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Cocoa
import TweenKit

class ViewController: NSViewController {
    
    private let scheduler = ActionScheduler()
    private var position = CGFloat(0)
    private var hasStartedAnimation = false
    private var squareView = NSView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.white.cgColor
        
        squareView.wantsLayer = true
        squareView.layer?.backgroundColor = NSColor.red.cgColor
        view.addSubview(squareView)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        if !hasStartedAnimation {
            startAnimation()
            hasStartedAnimation = true
        }
        
    }
    
    private func startAnimation() {
        
        let action = InterpolationAction(from: CGFloat(0),
                                         to: 1,
                                         duration: 1,
                                         easing: .sineInOut) { [weak self] (value) in
                                            self?.position = value
                                            self?.view.needsLayout = true
        }
        
        scheduler.run(action: action.yoyo().repeatedForever())
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        let squareSize = CGFloat(40)
        let maxX = view.bounds.width - squareSize
        
        squareView.frame = NSRect(x: maxX * position,
                                  y: view.bounds.midY - squareSize/2,
                                  width: squareSize,
                                  height: squareSize)
    }
}

