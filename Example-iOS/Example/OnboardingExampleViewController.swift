//
//  OnboardingExampleViewController.swift
//  Example
//
//  Created by Steven Barnegren on 30/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit
import TweenKit

/*
 The basic structure here, is that we have a horizontally scrolling collection view that is transparent.
 The collectionview cells have a label at the top, showing the text for each slide.
 
 There are also a bunch of full screen views underneith the collectionview that play the animations for various slides. (rocketView, clockView etc.)
 We build a single tweenkit action (composed of smaller sub actions for each thing we want to animate), where the duration is 1s per page.
 We can then use an ActionScrubber instance, and drive the action using the offset of the scrollview, mapping each page swipe to 1s.
 */

class OnboardingExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate let cellTitles: [String] = [
        "",
        "This is a rocket",
        "This is a clock",
        "Scrubbable animations",
        "Will make your onboarding rock"
    ]
    
    fileprivate var actionScrubber: ActionScrubber?
    fileprivate var hasAppeared = false
    
    fileprivate var showExclamation = false
    fileprivate var exclamationOriginY: CGFloat?
    
    fileprivate let backgroundColorView = {
        return BackgroundColorView()
    }()
    
    fileprivate let introView = {
        return IntroView()
    }()
    
    fileprivate let starsView = {
        return StarsView()
    }()
    
    fileprivate let rocketView = {
       return RocketView()
    }()
    
    fileprivate let clockView: ClockView = {
        let view = ClockView()
        view.isHidden = true
        return view
    }()
    
    fileprivate let tkAttributesView: TweenKitAttributesView = {
        let view = TweenKitAttributesView()
        return view
    }()
    
    fileprivate let exclamationLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        return layer
    }()
    
    fileprivate let collectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    fileprivate let pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: .zero)
        return pageControl
    }()
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Collection view
        collectionView.registerCellFromNib(withTypeName: OnboardingCell.typeName)
        
        // Page Control
        pageControl.numberOfPages = cellTitles.count
        
        // Add Subviews
        view.addSubview(backgroundColorView)
        view.addSubview(starsView)
        view.addSubview(rocketView)
        view.addSubview(clockView)
        view.addSubview(collectionView)
        view.addSubview(tkAttributesView)
        view.addSubview(introView)
        view.layer.addSublayer(exclamationLayer)
        view.addSubview(pageControl)
        
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
        introView.frame = view.bounds
        
        // tkAttributesView
        let attrY = view.bounds.size.height * 0.5
        tkAttributesView.frame = CGRect(x: 0, y: attrY, width: view.bounds.size.width, height: view.bounds.size.height - attrY)
        
        // Page Control
        pageControl.sizeToFit()
        pageControl.frame = CGRect(x: view.bounds.size.width/2 - pageControl.bounds.size.width/2,
                                   y: view.bounds.size.height - pageControl.bounds.size.height - 50,
                                   width: pageControl.bounds.size.width,
                                   height: pageControl.bounds.size.height)
        
        // Exclamation layer
        updateExclamationLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !hasAppeared {
            actionScrubber = ActionScrubber(action: buildAction())
            actionScrubber?.clampTValuesAboveOne = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hasAppeared = true
    }
    
    // MARK: - Build Action
    
    fileprivate func buildAction() -> FiniteTimeAction {
        
        let rocketAction = InterpolationAction(from: 0.0, to: 1.0, duration: 2.0, easing: .linear) {
            [unowned self] in
            self.rocketView.setRocketAnimationPct(t: $0)
        }
        
        let starsAction = InterpolationAction(from: 0.0, to: 1.0, duration: 2.0, easing: .linear) {
            [unowned self] in
            self.starsView.update(t: $0)
        }
        
        let introAction = InterpolationAction(from: 0.0, to: 1.0, duration: 1.0, easing: .linear) {
            [unowned self] in
            self.introView.update(t: $0)
        }
        
        return ActionGroup(actions:
            [introAction,
             rocketAction,
             starsAction,
             makeClockAction(),
             makeTkAttributesAction(),
             makeBackgroundColorsAction()]
        )
    }
    
    fileprivate func makeClockAction() -> FiniteTimeAction {
        
        // First page action (move clock on screen)
        let firstPageAction = InterpolationAction(from: 0.0,
                                               to: 1.0,
                                               duration: 1.0,
                                               easing: .linear) { [unowned self] in
                                                self.clockView.onScreenAmount = $0
        }
        
        // Second page action (move up and make small)
        let secondPageChangeTime = InterpolationAction(from: 23.0,
                                                       to: 24.0 + 4.0,
                                                       duration: 1.0,
                                                       easing: .linear) { [unowned self] in
                                                        self.clockView.hours = $0
        }
        
        let secondPageMoveClock = InterpolationAction(from: 1.0,
                                                      to: 1.3,
                                                      duration: 1.0,
                                                      easing: .linear) { [unowned self] in
            self.clockView.onScreenAmount = $0
        }
        
        let secondPageChangeSize = InterpolationAction(from: 1.0,
                                                       to: 0.5,
                                                       duration: 1.0,
                                                       easing: .linear) { [unowned self] in
            self.clockView.size = $0
        }
        
        let getClockPostion = RunBlockAction(handler: {
            [unowned self] in
            if self.exclamationOriginY == nil {
                self.exclamationOriginY = self.clockView.clockRect.origin.y
            }
        })
        
        let secondPageAction = ActionSequence(actions:
            [
                ActionGroup(actions: secondPageChangeTime, secondPageMoveClock, secondPageChangeSize),
                getClockPostion
            ])
                
        // Third page action (move to bottom)
        let thirdPageFillWhite = InterpolationAction(from: 0.0,
                                                  to: 1.0,
                                                  duration: 1.0,
                                                  easing: .linear) { [unowned self] in
                                                    self.clockView.fillOpacity = $0
        }
        
        let thirdPageMoveClock = InterpolationAction(from: { [unowned self] in self.clockView.onScreenAmount },
                                                     to: 0.55,
                                                     duration: 1.0,
                                                     easing: .linear) { [unowned self] in
            self.clockView.onScreenAmount = $0
            self.updateExclamationLayer()
        }
        
        thirdPageMoveClock.onBecomeActive = { [unowned self] in
            self.showExclamation = true
        }
        thirdPageMoveClock.onBecomeInactive = { [unowned self] in self.showExclamation = false }
        
        let thirdPageAction = ActionGroup(actions: thirdPageFillWhite, thirdPageMoveClock)
       
        
        // Full action
        let fullAction = ActionSequence(actions: firstPageAction, secondPageAction, thirdPageAction)
        fullAction.onBecomeActive = { [unowned self] in self.clockView.isHidden = false }
        fullAction.onBecomeInactive = { [unowned self] in self.clockView.isHidden = true }
        
        // Return full action with start delay
        return ActionSequence(actions: DelayAction(duration: 1.0), fullAction)
    }
    
    fileprivate func makeTkAttributesAction() -> FiniteTimeAction {
        
        let action = InterpolationAction(from: 0.0,
                                         to: 1.0,
                                         duration: 2,
                                         easing: .linear) { [unowned self] in
                                            self.tkAttributesView.update(pct: $0)
        }
        
        let delay = DelayAction(duration: 2.0)
        return ActionSequence(actions: delay, action)
    }
    
    fileprivate func makeBackgroundColorsAction() -> FiniteTimeAction {
        
        let startColors = (UIColor.black, UIColor.black)
        let spaceColors = (UIColor(red: 0.004, green: 0.000, blue: 0.063, alpha: 1.00),
                           UIColor(red: 0.031, green: 0.035, blue: 0.114, alpha: 1.00))
        let clockColors = (UIColor(red: 0.114, green: 0.110, blue: 0.337, alpha: 1.00),
                           UIColor(red: 0.114, green: 0.110, blue: 0.337, alpha: 1.00))
        let littleClockColors = (UIColor(red: 0.004, green: 0.251, blue: 0.631, alpha: 1.00),
                                 UIColor(red: 0.298, green: 0.525, blue: 0.776, alpha: 1.00))
        let exclamationColors = (UIColor(red: 0.149, green: 0.102, blue: 0.188, alpha: 1.00),
                                 UIColor(red: 0.149, green: 0.102, blue: 0.188, alpha: 1.00))
        
        let colors: [(UIColor, UIColor)] = [
            startColors,
            spaceColors,
            clockColors,
            littleClockColors,
            exclamationColors,
            ]
        
        var actions = [FiniteTimeAction]()
        
        for (startColors, endColors) in zip(colors, colors.dropFirst()) {
            
            let action = InterpolationAction(from: 0.0,
                                             to: 1.0,
                                             duration: 1.0,
                                             easing: .linear) {
                                                [unowned self] in
                                                let top = startColors.0.lerp(t: $0, end: endColors.0)
                                                let bottom = startColors.1.lerp(t: $0, end: endColors.1)
                                                self.backgroundColorView.setColors(top: top, bottom: bottom)
            }
            actions.append(action)
        }
        
        return ActionSequence(actions: actions)
    }
    
    // MARK: - Update ExclamationLayer
    
    fileprivate func updateExclamationLayer() {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        exclamationLayer.isHidden = true
        if showExclamation, let originY = exclamationOriginY {
            
            let bottomY = clockView.clockRect.origin.y - 30
            if bottomY > originY {
                
                exclamationLayer.isHidden = false
                exclamationLayer.frame = CGRect(x: view.bounds.size.width/2 - clockView.clockRect.width/2,
                                                y: originY,
                                                width: clockView.clockRect.width,
                                                height: bottomY - originY)
            }
        }
        
        CATransaction.commit()
    }

}

extension OnboardingExampleViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        
        let pageOffset = offset / view.bounds.size.width
        actionScrubber?.update(elapsedTime: Double(pageOffset))
        
        var currentPage = Int(pageOffset + 0.5)
        currentPage = max(currentPage, 0)
        currentPage = min(currentPage, cellTitles.count-1)
        pageControl.currentPage = currentPage
    }
}

extension OnboardingExampleViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCell.typeName, for: indexPath) as! OnboardingCell
        cell.setTitle(cellTitles[indexPath.row])
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


