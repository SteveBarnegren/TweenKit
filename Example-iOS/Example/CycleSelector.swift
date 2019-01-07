//
//  CycleSelector.swift
//  Example
//
//  Created by Steven Barnegren on 30/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit

class CycleSelector<T>: UIView {
    
    // MARK: - Types
    
    struct Option {
        let name: String
        let value: T
    }
    
    // MARK: - Public
    
    init(options: [(String, T)]) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.orange
        self.options = options.map{ Option(name: $0.0, value: $0.1) }
        self.selectedIndex = 0
        self.label.text = self.options.first?.name
        
        // Style
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 1
        
        // Add subviews
        addSubview(label)
        
        // Gesture recogniser
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(wasTapped))
        addGestureRecognizer(tapRecognizer)
    }
    
    var selectedValue: T {
        return options[selectedIndex].value
    }
    
    var onSelect: (T) -> () = {_ in}
    
    // MARK: - Properties
    
    var options = [Option]()
    var selectedIndex = 0
    
    let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkText
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - UIView

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    override func sizeToFit() {
        bounds.size = calculateIntrinsicSize()
    }
    
    override var intrinsicContentSize: CGSize {
        return calculateIntrinsicSize()
    }
    
    // MARK: - Methods
    
    @objc func wasTapped() {
        
        selectedIndex += 1
        if selectedIndex >= options.count {
            selectedIndex = 0
        }
        
        let option = options[selectedIndex]
        self.label.text = option.name
        onSelect(option.value)
    }
    
    func calculateIntrinsicSize() -> CGSize {
        
        let currentLabelText = label.text
        let orginalLabelFrame = label.frame
        
        var maxSize = CGSize.zero
        options.map{ $0.name }.forEach{
            label.text = $0
            label.sizeToFit()
            maxSize.width = max(label.bounds.size.width, maxSize.width)
            maxSize.height = max(label.bounds.size.height, maxSize.height)
        }
        
        label.text = currentLabelText
        label.frame = orginalLabelFrame
        
        let margin = CGFloat(5.0)
        return CGSize(width: maxSize.width + (margin*2),
                      height: maxSize.height + (margin*2))
    }
    
    
}
