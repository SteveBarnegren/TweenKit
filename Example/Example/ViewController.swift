//
//  ViewController.swift
//  Example
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit
import TweenKit

class ViewController: UIViewController {
    
    let testView: UIView = {
        let view = UIView(frame: .zero)
        view.frame.size = CGSize(width: 30, height: 30)
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    let slider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isUserInteractionEnabled = true
        slider.isContinuous = true
        return slider
    }()
    
    let action: InterpolationAction<CGPoint> = {
        let action = InterpolationAction<CGPoint>()
        return action
    }()
    
    var lastTimeStamp: CFTimeInterval?
    var elapsedTime: CFTimeInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Subviews
        view.addSubview(testView)
        view.addSubview(slider)
        
        
        // Setup the action
        action.startValue = CGPoint(x: 0, y: 0)
        action.endValue = CGPoint(x: 200, y: 200)
        action.updateHandler = {
            newPoint in
            self.testView.frame.origin = newPoint
        }
        
        // Start the display link
        startDisplayLink()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Layout Slider
        slider.sizeToFit()
        let margin = CGFloat(5)
        slider.frame = CGRect(x: margin,
                              y: view.bounds.size.height - slider.bounds.size.height - 30,
                              width: view.bounds.size.width - (margin * 2),
                              height: slider.bounds.size.height);
    }
    
    // MARK: - DisplayLink
    
    func startDisplayLink() {
        let displaylink = CADisplayLink(target: self,
                                        selector: #selector(step))
        
        displaylink.add(to: .current,
                        forMode: .defaultRunLoopMode)
    }
    
    func step(displaylink: CADisplayLink) {
        print(displaylink.timestamp)
        
        let duration = Double(2.5)
        
        // We need a previous time stamp to check against. Save if we don't already have one
        guard let last = lastTimeStamp else{
            lastTimeStamp = displaylink.timestamp
            return
        }
        
        // Increase elapsed time
        let dt = displaylink.timestamp - last
        elapsedTime += dt
        
        // Wrap if required
        if elapsedTime > duration {
            elapsedTime -= duration
        }
        
        // Update the action
        action.updateWithTime(t: elapsedTime / duration)
        
        // Save the current time
        lastTimeStamp = displaylink.timestamp
        
    }
    
    // MARK: - Slider callback
    func sliderValueChanged() {
        print("Slider value changed")
        action.updateWithTime(t: Double(slider.value))
    }
   
}

