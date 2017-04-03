//
//  OnboardingExampleViewController.swift
//  Example
//
//  Created by Steven Barnegren on 30/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit
import TweenKit

class OnboardingExampleViewController: UIViewController {
    
    
    // MARK: - Properties
    
    var actionScrubber: ActionScrubber?
    var hasAppeared = false
    
    let backgroundColorView = {
        return BackgroundColorView()
    }()
    
    let starsView = {
       return StarsView()
    }()
    
    let rocketView = {
       return RocketView()
    }()
    
    let collectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Collection view
        registerCells()
        
        // Add Subviews
        view.addSubview(backgroundColorView)
        view.addSubview(starsView)
        view.addSubview(rocketView)
        view.addSubview(collectionView)
        
        // Reload
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        rocketView.frame = view.bounds
        starsView.frame = view.bounds
        backgroundColorView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !hasAppeared {
            actionScrubber = ActionScrubber(action: buildAction())
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hasAppeared = true
    }
    
    // MARK: - Methods
    
    func buildAction() -> FiniteTimeAction {
        
        let rocketAction = InterpolationAction(from: 0.0, to: 1.0, duration: 2.0, easing: .linear) {
            [unowned self] in
            self.rocketView.setRocketAnimationPct(t: $0)
        }
        
        let starsAction = InterpolationAction(from: 0.0, to: 1.0, duration: 1.0, easing: .linear) {
            [unowned self] in
            self.starsView.update(t: $0)
        }
        
        return Group(actions: rocketAction, starsAction, makeBackgroundColorsAction())
    }
    
    func makeBackgroundColorsAction() -> FiniteTimeAction {
        
        let colors: [(UIColor, UIColor)] = [
            // Start
            (
                UIColor.black,
                UIColor.black
            ),
            // Space
            (
                UIColor(red: 0.004, green: 0.000, blue: 0.063, alpha: 1.00),
                UIColor(red: 0.031, green: 0.035, blue: 0.114, alpha: 1.00)
            ),
            ]
        
        let toSpaceColors = InterpolationAction(from: 0.0,
                                                to: 1.0,
                                                duration: 1.0,
                                                easing: .linear) {
                                                    [unowned self] in
                                                    let startColors = colors[0]
                                                    let endColors = colors[1]
                                                    let top = startColors.0.lerp(t: $0, end: endColors.0)
                                                    let bottom = startColors.1.lerp(t: $0, end: endColors.1)
                                                    self.backgroundColorView.setColors(top: top, bottom: bottom)
        }
        
        return toSpaceColors
    }
    
    func registerCells() {
        collectionView.registerCellFromNib(withTypeName: OnboardingCellHello.typeName)
    }
}

extension OnboardingExampleViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        
        let pageOffset = offset / view.bounds.size.width
        print("Offset: \(pageOffset)")
        actionScrubber?.update(elapsedTime: Double(pageOffset))
    }
}

extension OnboardingExampleViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCellHello.typeName, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

// MARK: - UITableView Register cells

extension UICollectionView {
    
    func registerCellFromNib(withTypeName typeName: String) {
        
        let nib = UINib(nibName: typeName, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: typeName)
    }
}

// MARK: - Type Name Provider

protocol TypeNameProvider {
    static var typeName: String {get}
}

extension TypeNameProvider {
    static var typeName: String {
        return String(describing: Self.self)
    }
}

extension NSObject: TypeNameProvider {}


