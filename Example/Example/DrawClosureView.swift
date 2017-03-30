//
//  DrawClosureView.swift
//  Example
//
//  Created by Steven Barnegren on 30/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit

class DrawClosureView: UIView {

    // MARK: - Public
    
    var drawClosure: () -> () = {}
    
    init() {
        super.init(frame: .zero)
    }
    
    init(closure: @escaping () -> ()) {
        
        self.drawClosure = closure
        super.init(frame: .zero)
    }
    
    func redraw() {
        self.setNeedsDisplay()
    }
    
    // MARK: - UIView
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.clear.cgColor)
        context?.clear(rect)
        //context?.fill(rect)
        
        drawClosure()
    }
 
}
