//
//  BasicTweenViewController.swift
//  Example
//
//  Created by Steven Barnegren on 23/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit
import TweenKit

class BasicTweenViewController: UIViewController {
    
    // Create a scheuler - used to run actions
    let scheduler = Scheduler()
    
    // The view we will be animating
    let squareView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.red
        view.center = CGPoint(x: 100, y: 100)
        view.frame.size = CGSize(width: 70, height: 70)
        return view
    }()

    // Start the animation on view did load
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.addSubview(squareView)
        startAnimation()
    }
    
    func startAnimation() {
        
        // Work out the new frame that we want the view to have
        let newWidth = CGFloat(200)
        let newHeight = CGFloat(100)
        let newFrame = CGRect(x: self.view.center.x - newWidth/2,
                              y: self.view.center.y - newHeight/2,
                              width: newWidth,
                              height: newHeight)
        
        // Create an interpolation action
        // We can use a closure for the from argument to get the current frame of the view
        // Note the use of [unowned self] closures to break retain cycle, as scheduler has the same lifetime as self
        let action = InterpolationAction(from: { [unowned self] in self.squareView.frame },
                                         to: newFrame,
                                         duration: 2,
                                         update: { [unowned self] in self.squareView.frame = $0 })
        action.easing = .exponentialInOut
        
        
        // Yoyo (run the action back and forth), and repeat it forever
        // You can construct YoyoAction and RepeatForeverAction objects manually, but it's easier to use the convenience functions
        let repeatedAction = action.yoyo().repeatedForever()
        
        // Run the action
        scheduler.run(action: repeatedAction)
    }
    
}
