# TweenKit

[![CI Status](https://api.travis-ci.org/SteveBarnegren/TweenKit.svg?branch=master)](https://travis-ci.org/SteveBarnegren/TweenKit)
[![Version](https://img.shields.io/cocoapods/v/TweenKit.svg?style=flat)](http://cocoapods.org/pods/TweenKit)
[![License](https://img.shields.io/cocoapods/l/TweenKit.svg?style=flat)](http://cocoapods.org/pods/TweenKit)
[![Platform](https://img.shields.io/cocoapods/p/TweenKit.svg?style=flat)](http://cocoapods.org/pods/TweenKit)
[![Twitter](https://img.shields.io/badge/contact-@stevebarnegren-blue.svg?style=flat)](https://twitter.com/stevebarnegren)

TweenKit is a powerful animation library that allows you to animate (or 'tween') anything. TweenKit's animations are also scrubbable, perfect for building awesome onboarding experiences!

![tweenkit](https://cloud.githubusercontent.com/assets/6288713/25148841/31245f10-2474-11e7-927d-4045fb88ad52.gif)

Download the example project to see how these animations were created

TweenKit's animations are:

* Reversible
* Repeatable
* Groupable
* Sequenceable
* Scrubbable
* Quick and easy to use!

## Example

The example project contains a collection of examples of how to use TweenKit. Run `Example.xcodeproj`

## Installation

TweenKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TweenKit"
```

## Importing TweenKit



Add `import TweenKit` to the top of the files you want to use TweenKit from

## Creating an ActionScheduler

Create an instance of `ActionScheduler` to run your animations. You should retain the scheduler, so it's best made as a property on your View Controller.

```
let scheduler = ActionScheduler()
```

## Actions

TweenKit's animations are composed of 'Actions'. These are small animation units that can be chained or grouped to build complex animations. Once you have created an action, you can tell the scheduler to run it.

```
scheduler.run(action: myAction)
```

## Animating a view's frame

Anything that conforms to the 'Tweenable' protocol, can be animated.

CGRect, CGFloat, Double, Float, UIColor, and other common objects already adopt the 'Tweenable' out of the box.

We can use TweenKit's `InterpolationAction` to animate a view's frame:

```
let fromRect = CGRect(x: 50, y: 50, width: 40, height: 40)
let toRect = CGRect(x: 100, y: 100, width: 200, height: 100)
        
let action = InterpolationAction(from: fromRect,
                                 to: toRect,
                                 duration: 1.0,
                                 easing: .exponentialInOut) {
                                    [unowned self] in self.redView.frame = $0
}
        
scheduler.run(action: action)
```
![basictween](https://cloud.githubusercontent.com/assets/6288713/24793903/a4d1b0b8-1b7b-11e7-925d-42deea17faeb.gif)

## Grouping actions

Using an `ActionGroup`, several animations can be run at once. For instance, we can change a view's frame and it's background color:

```
// Create a move action
let fromRect = CGRect(x: 50, y: 50, width: 40, height: 40)
let toRect = CGRect(x: 100, y: 100, width: 200, height: 100)
        
let move = InterpolationAction(from: fromRect,
                                 to: toRect,
                                 duration: 2.0,
                                 easing: .elasticOut) {
                        [unowned self] in self.squareView.frame = $0
}
        
// Create a color change action
let changeColor = InterpolationAction(from: UIColor.red,
                                      to: UIColor.orange,
                                      duration: 2.0,
                                      easing: .exponentialOut) {
                        [unowned self] in self.squareView.backgroundColor = $0
}
        
// Make a group to run them at the same time
let moveAndChangeColor = ActionGroup(actions: move, changeColor)
scheduler.run(action: moveAndChangeColor)
```

![grouptween](https://cloud.githubusercontent.com/assets/6288713/24795622/d9c06778-1b81-11e7-9c8b-c44c614e7528.gif)

## Running actions in sequence

Using an `ActionSequence`, several animations can be run in order. This time, we can use supply a closure as the 'from' parameter, to animate the view from it's current frame:

```
let moveOne = InterpolationAction(from: { [unowned self] in self.squareView.frame },
                                  to: CGRect(x: 120, y: 80, width: 50, height: 50),
                                  duration: 1,
                                  easing: .exponentialInOut) {
                                   [unowned self] in self.squareView.frame = $0
}
        
let moveTwo = InterpolationAction(from: { [unowned self] in self.squareView.frame },
                                  to: CGRect(x: 70, y: 120, width: 130, height: 130),
                                  duration: 1,
                                  easing: .exponentialInOut) {
                                    [unowned self] in self.squareView.frame = $0
}
        
let moveTwice = ActionSequence(actions: moveOne, moveTwo)
scheduler.run(action: moveTwice)
```

![sequencetween](https://cloud.githubusercontent.com/assets/6288713/24795989/3486bcba-1b83-11e7-8e2d-cdce94c451ad.gif)

## Repeating actions

Use `RepeatAction` to repeat your actions, or `RepeatForeverAction` to repeat an action forever. You can easily contruct these using the `repeated(times:)` and `repeatedForever` methods on any action:

```
let repeatedForever = myAction.repeatedForever()
scheduler.run(action: repeatedForever)
```

## Yoyo

If you want your action to go back and forth, you can use a `YoyoAction`. These can be easily constructed by calling the `yoyo()` method on any action:

```
let move = InterpolationAction(from: { [unowned self] in self.squareView.frame },
                               to: CGRect(x: 250, y: 100, width: 100, height: 100),
                               duration: 1,
                               easing: .exponentialInOut) {
                                [unowned self] in self.squareView.frame = $0
}
        
scheduler.run(action: move.yoyo().repeatedForever() )
```
![yoyotween](https://cloud.githubusercontent.com/assets/6288713/24805340/49231f76-1ba9-11e7-9832-2ce5da836947.gif)

## Arc Actions

`ArcAction` can animate any object that conforms to `Tweenable2DCoordinate` in a circular motion.

By creating some `ArcAction`s  in a staggared `Group`, we can easily create an activity indicator:

```
// Create an ArcAction for each circle layer
let actions = circleLayers.map{
    layer -> ArcAction<CGPoint> in
            
    let action = ArcAction(center: self.view.center,
                           radius: radius,
                           startDegrees: 0,
                           endDegrees: 360,
                           duration: 1.3) {
                            [unowned layer] in layer.center = $0
    }
    action.easing = .sineInOut
    return action
}
        
// Run the actions in a staggered group
let group = ActionGroup(staggered: actions, offset: 0.125)
        
// Repeat forever
let repeatForever = group.repeatedForever()
        
// Run the action
scheduler.run(action: repeatForever)
```

![activityindicator](https://cloud.githubusercontent.com/assets/6288713/24805875/f4b39e0a-1baa-11e7-9e3d-ba8116ec27c5.gif)

## Bezier Actions

Objects can be animated along a bezier path using `BezierAction`. The callback supplies both position and rotation.

BezierAction can animate any value that conforms to the `Tweenable2DCoordinate` protocol.

```        
let action = BezierAction(path: bezierPath, duration: 4.0) {
    [unowned self] (postion, rotation) in
            
    self.rocketImageView.center = postion
            
    let rocketRotation = CGFloat(rotation.value)
    self.rocketImageView.transform = CGAffineTransform(rotationAngle: rocketRotation)
}
    
action.easing = .exponentialInOut
        
scheduler.run(action: action)
```

![rocket](https://cloud.githubusercontent.com/assets/6288713/24763091/43de5858-1ae8-11e7-9e70-3e5d4dc182eb.gif)

## Scrubbable actions

Scrubbable Actions are great for building unique onboarding experiences.

Instead of adding the action to a scheduler, create an `ActionScrubber` instance:

```     
let move = InterpolationAction(from: { [unowned self] in self.squareView.frame },
                               to: CGRect(x: 130, y: 100, width: 100, height: 100),
                               duration: 1,
                               easing: .elasticOut) {
                                [unowned self] in self.squareView.frame = $0
}
        
self.actionScrubber = ActionScrubber(action: move)

// Scrub the action in a UISlider callback
func sliderChanged(slider: UISlider) {
    actionScrubber.update(t: Double(slider.value))
}
```

![scrubbabletween](https://cloud.githubusercontent.com/assets/6288713/24806390/9955ef7a-1bac-11e7-901c-625e8283487f.gif)

## Animating your own objects

By adding conformance to the `Tweenable` protocol, anything can be animated. You decide what it means to 'tween' your object, making this a flexible approach.

For instance, by conforming `String` to `Tweenable` we can turn a **bat** into a **cat**:

```
InterpolationAction(from: "bat",
                    to: "cat",
                    duration: 4,
                    easing: .exponentialInOut) {
                     [unowned self] in self.label.text = $0
}
```

![battocat](https://cloud.githubusercontent.com/assets/6288713/24763350/04d6c82e-1ae9-11e7-9aa8-d0ec97cdd8f1.gif)

## Other Stuff

Use `DelayAction` to add a delay in to a sequence

Use `CallBlockAction` to trigger a callback at any point in a sequence

## Author

Steve Barnegren

steve.barnegren@gmail.com

@stevebarnegren

## License

TweenKit is available under the MIT license. See the LICENSE file for more info.
