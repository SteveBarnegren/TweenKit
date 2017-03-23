//
//  ExampleViewController.swift
//  Example
//
//  Created by Steven Barnegren on 23/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    var contentViewController: UIViewController? = nil
    
    // MARK: - Views
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.addTarget(self, action: #selector(nextButtonPressed(sender:)), for: .touchUpInside)
        return button
    }()

    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        // Add subviews
        view.addSubview(backButton)
        view.addSubview(nextButton)
        
        // Set the initial content view controller
        //setContentViewController(to: BasicTweenViewController(nibName: nil, bundle: nil))
        setContentViewController(to: ActivityIndicatorExampleViewController(nibName: nil, bundle: nil))

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let buttonMargins = CGFloat(8)
        
        // Back button
        backButton.sizeToFit()
        backButton.frame.origin = CGPoint(x: buttonMargins,
                                          y: view.bounds.size.height - buttonMargins - backButton.bounds.size.height)
        
        // Next button
        nextButton.sizeToFit()
        nextButton.frame.origin = CGPoint(x: view.bounds.size.width - buttonMargins - nextButton.bounds.size.width,
                                          y: view.bounds.size.height - buttonMargins - nextButton.bounds.size.height)
        
        // Content view controller
        if let content = contentViewController {
            
            content.view.frame = CGRect(x: 0,
                                        y: 0,
                                        width: self.view.bounds.size.width,
                                        height: backButton.frame.origin.y - buttonMargins)
        }
    }
    
    @objc private func backButtonPressed(sender: UIButton) {
        print("Back button pressed")
    }

    @objc private func nextButtonPressed(sender: UIButton) {
        print("Next button pressed")
    }
    
    func setContentViewController(to viewController: UIViewController) {
        
        if let existing = contentViewController {
            existing.removeFromParentViewController()
            existing.view.removeFromSuperview()
        }
        
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        
        view.setNeedsLayout()
    }
    

}
