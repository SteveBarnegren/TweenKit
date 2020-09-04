//
//  StringTweenViewController.swift
//  Example
//
//  Created by Steven Barnegren on 06/04/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit
import TweenKit

let alphabetString = "abcdefghijklmnopqrstuvwxyz"

func convertCharacterToInt(_ character: Character) -> Int {
    
    for (index, char) in alphabetString.enumerated() {
        if char == character {
            return index
        }
    }
    
    fatalError("Unable to convert character to int: \(character)")
}

func convertIntToCharacter(_ int: Int) -> Character {
    
    for (index, char) in alphabetString.enumerated() {
        if index == int {
            return char
        }
    }
    
    fatalError("Unable to convert int to character: \(int)")
}

extension Int: Tweenable {
    
    public func lerp(t: Double, end: Int) -> Int {
        print("t = \(t)")
        let intT = Int(t)
        return self + ((end - self) * intT)
    }
    
    public func distanceTo(other: Int) -> Double {
        fatalError("Not implemented")
    }
    
}

extension String: Tweenable {
    
    public func lerp(t: Double, end: String) -> String {
        
        // This is a really naive implementation that doesn't handle edge (or even common) cases
        // If you want to use this in production, you should implement something more robust
        // Long strings also suffer from floating point precision issues
        
        precondition(self.count == end.count)
        
        // 'Snap' near the ends
        if t < 0.00001 {
            return self
        }
        if t > 1 - 0.0005 {
            return end
        }
        
        let fromNumber = self.asNumber()
        let toNumber = end.asNumber()
        
        let interpolated = Double(fromNumber).lerp(t: t, end: Double(toNumber))
        return String(number: Int(interpolated), length: self.count)
    }
    
    init(number: Int, length: Int) {
        
        var characters = [Character]()
        
        for index in (0..<length) {
            
            if index == length-1 {
                let charNum = number % 26
                characters.append( convertIntToCharacter(charNum) )
            }
            else{

                let distanceFromEnd = length - index - 1
                var num = number
                (0..<distanceFromEnd).forEach{ _ in
                    num /= 26
                }
                num -= 1
                num = num % 26
                characters.append( convertIntToCharacter(num) )
            }
        }
        
        self.init(characters)
    }
    
    func asNumber() -> Int {
        
        var cumulative = 0
        
        for (index, char) in self.reversed().enumerated() {
         
            var num = convertCharacterToInt(char)
            
            if index == 0 {
                cumulative += num
            }
            else{
                num += 1
                (0..<index).forEach{ _ in
                    num *= 26
                }
                cumulative += num

            }
        }
        return cumulative
    }
   
    var alphabetLength: Int {
        return alphabetString.count
    }

    public func distanceTo(other: String) -> Double {
        fatalError("Not implemented")
    }
}


class StringTweenViewController: UIViewController {
    
    private let scheduler = ActionScheduler(automaticallyAdvanceTime: true)
    
    private let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "bat"
        label.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight(rawValue: 4))
        label.textAlignment = .center
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(label)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Turn 'bat' in to 'cat'
        let action = InterpolationAction(from: "bat", to: "cat", duration: 4, easing: .exponentialInOut) { [unowned self] in
            self.label.text = $0
        }
        
        // Create a sequence a delay at each end
        let sequence = ActionSequence(actions: DelayAction(duration: 0.5), action, DelayAction(duration: 0.5))
        
        // Run it forever
        scheduler.run(action: sequence.yoyo().repeatedForever())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.frame = view.bounds
    }


}
