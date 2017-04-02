//
//  BackgroundColorView.swift
//  Example
//
//  Created by Steven Barnegren on 31/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit

class BackgroundColorView: UIView {
    
    func setColors(top: UIColor, bottom: UIColor) {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        gradientLayer.colors = [top.cgColor, bottom.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0.0, 1.0]
        
        CATransaction.commit()
    }
    
    // MARK: - Properties
    
    let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        return layer
    }()
    
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(gradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.frame = bounds
    }


   

}
