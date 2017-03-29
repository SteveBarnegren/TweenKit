//
//  ViewController.swift
//  Example
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit
import TweenKit

class TestViewController: UIViewController {
    
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
    
    let scheduler = Scheduler()
    var lastTimeStamp: CFTimeInterval?
    var elapsedTime: CFTimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        // Add Subviews
        view.addSubview(testView)
        view.addSubview(slider)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        perform(#selector(startTheAnimation), with: nil, afterDelay: 3)
    }
    
    func startTheAnimation() {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 100, y: 200))
        path.addCurve(to: CGPoint(x: 300, y: 200),
                      controlPoint1: CGPoint(x: 175, y: 0),
                      controlPoint2: CGPoint(x: 275, y: 500))
        //path.close()

        let bezierPath = path.asBezierPath()
        
        let action = BezierAction(path: bezierPath,
                     duration: 2,
                     update: { [unowned self] in self.testView.center = $0 })
        
        let animation = Animation(action: action.yoyo())
        scheduler.add(animation: animation)
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
    }
   
}

