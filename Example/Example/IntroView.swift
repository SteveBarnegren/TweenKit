//
//  IntroView.swift
//  Example
//
//  Created by Steven Barnegren on 05/04/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit
import TweenKit

class IntroView: UIView {
    
    // MARK: - Public
    
    func update(t: Double) {
        actionScrubber.update(t: t)
    }
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = false
        
        // Add subviews
        addSubview(topLabel)
        addSubview(bottomLabel)
        
        // Create action
        let moveAction = InterpolationAction(from: labelSeparation,
                                         to: 200,
                                         duration: 1.0,
                                         easing: .linear, update: { [unowned self] in
                                            self.labelSeparation = $0
                                            self.setNeedsLayout()
        })
        
        let alphaAction = InterpolationAction(from: CGFloat(1.0),
                                              to: CGFloat(0.0),
                                              duration: 1.0,
                                              easing: .linear) {
            [unowned self] in
            self.topLabel.alpha = $0
            self.bottomLabel.alpha = $0
        }
        
        let group = ActionGroup(actions: moveAction, alphaAction)
        actionScrubber = ActionScrubber(action: group)
    }
    
    // MARK: - Properties
    
    var labelSeparation = CGFloat(16)
    var actionScrubber: ActionScrubber!
    
    private let topLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Onboarding with".uppercased()
        label.font = UIFont.systemFont(ofSize: 16, weight: 3)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "TweenKit"
        label.font = UIFont.systemFont(ofSize: 16, weight: 3)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    // MARK: - UIView
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topLabel.frame = CGRect(x: 0,
                                y: frame.size.height/2 - topLabel.bounds.size.height - labelSeparation/2,
                                width: bounds.size.width,
                                height: topLabel.bounds.size.height)
        
        bottomLabel.frame = CGRect(x: 0,
                                   y: frame.size.height/2 + labelSeparation/2,
                                   width: bounds.size.width,
                                   height: bottomLabel.bounds.size.height)

    }

}
