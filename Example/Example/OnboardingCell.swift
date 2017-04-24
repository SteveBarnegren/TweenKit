//
//  OnboardingCellHello.swift
//  Example
//
//  Created by Steven Barnegren on 31/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
    
    // MARK: - Public
    
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak private var titleLabel: UILabel!
    
    // MARK: - UICollectionViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
    }
    
}
