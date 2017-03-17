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
    
    // MARK: - Slider callback
    func sliderValueChanged() {
        print("Slider value changed")
        action.updateWithTime(t: Double(slider.value))
    }
   
}

