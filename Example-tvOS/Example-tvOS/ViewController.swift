//
//  ViewController.swift
//  Example-tvOS
//
//  Created by Steve Barnegren on 07/01/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import UIKit
import TweenKit

class ViewController: UIViewController {
    
    let squareView = UIView(frame: .zero)
    let scheduler = ActionScheduler()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimating()
    }
    
    func startAnimating() {
        
        squareView.backgroundColor = .red
        view.addSubview(squareView)
        
        let sideLength = CGFloat(300)
        
        let startRect = CGRect(x: 0,
                               y: view.bounds.height/2 - sideLength/2,
                               width: sideLength,
                               height: sideLength)
        
        let endRect = CGRect(x: view.bounds.width - sideLength,
                             y: view.bounds.height/2 - sideLength/2,
                             width: sideLength,
                             height: sideLength)
        
        squareView.frame = startRect
        let action = InterpolationAction(from: startRect,
                                         to: endRect,
                                         duration: 1,
                                         easing: .sineInOut,
                                         update: { [unowned self] in self.squareView.frame = $0 })

        scheduler.run(action: action.yoyo().repeatedForever())
    }

}
