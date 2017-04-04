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
    
    let cellTitles: [String] = [
        "",
        "This is a rocket",
        "This is a clock",
        "Scrubbable animations",
        "Will make your onboarding rock"
    ]
    
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
    
    let clockView: ClockView = {
        let view = ClockView()
        view.isHidden = true
        return view
    }()
    
    let tkAttributesView: TweenKitAttributesView = {
        let view = TweenKitAttributesView()
        return view
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
        view.addSubview(clockView)
        view.addSubview(collectionView)
        view.addSubview(tkAttributesView)
        
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
        
        let attrY = view.bounds.size.height * 0.5
        tkAttributesView.frame = CGRect(x: 0, y: attrY, width: view.bounds.size.width, height: view.bounds.size.height - attrY)
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
        
        let starsAction = InterpolationAction(from: 0.0, to: 1.0, duration: 2.0, easing: .linear) {
            [unowned self] in
            self.starsView.update(t: $0)
        }
        
        return Group(actions:
            [rocketAction,
            starsAction,
            makeClockAction(),
            makeTkAttributesAction(),
            makeBackgroundColorsAction()]
        )
    }
    
    func makeClockAction() -> FiniteTimeAction {
        
        // First page action
        let firstPageAction = InterpolationAction(from: 0.0,
                                               to: 1.0,
                                               duration: 1.0,
                                               easing: .linear) { [unowned self] in
                                                self.clockView.onScreenAmount = $0
        }
        
        // Second page action
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
        
        let secondPageChangeSize = InterpolationAction(from: 1.0, to: 0.5, duration: 1.0, easing: .linear) { [unowned self] in
            self.clockView.size = $0
        }
        
        let secondPageAction = Group(actions: secondPageChangeTime, secondPageMoveClock, secondPageChangeSize)
        
        // Third page action
        let thirdPageFillWhite = InterpolationAction(from: 0.0,
                                                  to: 1.0,
                                                  duration: 1.0,
                                                  easing: .linear) { [unowned self] in
                                                    self.clockView.fillOpacity = $0
        }
        
        let thirdPageMoveClock = InterpolationAction(from: { [unowned self] in self.clockView.onScreenAmount }, to: 0.4, duration: 1.0, easing: .linear) { [unowned self] in
            self.clockView.onScreenAmount = $0
        }
        
        let thirdPageAction = Group(actions: thirdPageFillWhite, thirdPageMoveClock)
        
        // Full action
        let fullAction = Sequence(actions: firstPageAction, secondPageAction, thirdPageAction)
        fullAction.onBecomeActive = { [unowned self] in self.clockView.isHidden = false }
        fullAction.onBecomeInactive = { [unowned self] in self.clockView.isHidden = true }
        
        // Return full action with start delay
        return Sequence(actions: DelayAction(duration: 1.0), fullAction)
    }
    
    func makeTkAttributesAction() -> FiniteTimeAction {
        
        let action = InterpolationAction(from: 0.0,
                                         to: 1.0,
                                         duration: 2,
                                         easing: .linear) { [unowned self] in
                                            self.tkAttributesView.update(pct: $0)
        }
        
        let delay = DelayAction(duration: 2.0)
        return Sequence(actions: delay, action)
    }
    
    func makeBackgroundColorsAction() -> FiniteTimeAction {
        
        let startColors = (UIColor.black, UIColor.black)
        let spaceColors = (UIColor(red: 0.004, green: 0.000, blue: 0.063, alpha: 1.00),
                           UIColor(red: 0.031, green: 0.035, blue: 0.114, alpha: 1.00))
        let clockColors = (UIColor(red: 0.114, green: 0.110, blue: 0.337, alpha: 1.00),
                           UIColor(red: 0.114, green: 0.110, blue: 0.337, alpha: 1.00))
        let sunColors = (UIColor(red: 0.004, green: 0.251, blue: 0.631, alpha: 1.00),
                         UIColor(red: 0.298, green: 0.525, blue: 0.776, alpha: 1.00))
        
        let colors: [(UIColor, UIColor)] = [
           startColors,
           spaceColors,
           clockColors,
           sunColors,
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
        
        return Sequence(actions: actions)
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
        return cellTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCellHello.typeName, for: indexPath) as! OnboardingCellHello
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


