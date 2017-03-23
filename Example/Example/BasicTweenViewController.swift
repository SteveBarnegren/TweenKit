//
//  BasicTweenViewController.swift
//  Example
//
//  Created by Steven Barnegren on 23/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit

class BasicTweenViewController: UIViewController {
    
    let squareView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.red
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(squareView)
        reset()
    }
    
    func reset(){
        squareView.frame = CGRect(x: 100,
                                  y: 100,
                                  width: 50,
                                  height: 50)
    }
    
    func startAnimation() {
        
        
    }
    
}
