//
//  EasingExampleCell.swift
//  Example
//
//  Created by Steven Barnegren on 27/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit

class EasingExampleCell: UITableViewCell {
    
    // MARK: - Public
    
    func setTitle(title: String) {
        self.titleLabel.text = title
    }
    
    var animatedPct = 0.0 {
        didSet{
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    // MARK: - Views
    @IBOutlet weak private var easingContainerView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    
    let squareLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.blue.cgColor
        return layer
    }()
    
    // MARK: - Properties
    
    // MARK: - UITableViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        easingContainerView.layer.addSublayer(squareLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let sideLength = Swift.min(easingContainerView.bounds.size.width,
                                   easingContainerView.bounds.size.height)
        let min = CGFloat(0.0)
        let max = easingContainerView.bounds.size.width - sideLength
        
        let x = min + ((max - min) * CGFloat(animatedPct))
        squareLayer.frame = CGRect(x: x,
                                   y: 0,
                                   width: sideLength,
                                   height: sideLength)
        
        CATransaction.commit()
    }
    
    
}
