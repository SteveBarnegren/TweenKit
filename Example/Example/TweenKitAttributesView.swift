//
//  TweenKitAttributesView.swift
//  Example
//
//  Created by Steven Barnegren on 04/04/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit
import TweenKit

class TweenKitAttributesView: UIView {
    
    // MARK: - Internal
    
    init() {
        
        super.init(frame: .zero)
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.clear
        
        // Make the labels
        for info in labelsInfo {
            
            let label = UILabel(frame: .zero)
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.text = info.title
            labels.append(label)
            addSubview(label)
        }
        
        // Make the action
        var actions = [FiniteTimeAction]()
        
        let duration = 0.8
        for index in (0..<labelsInfo.count) {
            
            let action = InterpolationAction(from: CGFloat(0), to: CGFloat(1), duration: 1.0, easing: .sineInOut, update: { [unowned self] in
                self.labelsInfo[index].pctVisible = $0
            })
            actions.append(action)
        }
        
        let offset = (1.0 - duration) / Double(self.labelsInfo.count)
        let fullAction = ActionGroup(staggered: actions, offset: offset)
        actionScrubber = ActionScrubber(action: fullAction.yoyo())
        
    }
    
    func update(pct: Double) {
        
        actionScrubber?.update(t: pct)
        setNeedsLayout()
    }
    
    // MARK: - Properties
    
    private class LabelInfo {
        let title: String
        var pctVisible: CGFloat
        init(title: String) {
            self.title = title
            pctVisible = 0.0
        }
    }
    
    private var actionScrubber: ActionScrubber? = nil
    private let labelsInfo = [LabelInfo(title: "Scrubbable"),
                              LabelInfo(title: "Reverseable"),
                              LabelInfo(title: "Groupable"),
                              LabelInfo(title: "Sequenceable")]
    
    private var labels = [UILabel]()
    
    // MARK: - UIView
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let containerHeight = bounds.size.height - 100
        let labelHeight = containerHeight / CGFloat(labels.count)
        
        for (index, label) in labels.enumerated() {
            
            let labelInfo = labelsInfo[index]
            
            let inY = labelHeight * CGFloat(index)
            let outY = inY + bounds.size.height
            let y = outY.lerp(t: Double(labelInfo.pctVisible), end: inY)
            
            label.frame = CGRect(x: 0,
                                  y: y,
                                  width: bounds.size.width,
                                  height: labelHeight)
            
        }
        
    }
  
}
