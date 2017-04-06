# TweenKit

[![CI Status](http://img.shields.io/travis/steve.barnegren@gmail.com/TweenKit.svg?style=flat)](https://travis-ci.org/steve.barnegren@gmail.com/TweenKit)
[![Version](https://img.shields.io/cocoapods/v/TweenKit.svg?style=flat)](http://cocoapods.org/pods/TweenKit)
[![License](https://img.shields.io/cocoapods/l/TweenKit.svg?style=flat)](http://cocoapods.org/pods/TweenKit)
[![Platform](https://img.shields.io/cocoapods/p/TweenKit.svg?style=flat)](http://cocoapods.org/pods/TweenKit)

TweenKit is a powerful animation library that allows you to animate (or 'tween') anything. TweenKit's animations are also scrubbable; perfect for building awesome onboarding experiences!

!!!GIFs!!!

TweenKit's animations are:

* Reveseable
* Repeatable
* Groupable
* Sequenceable
* Scrubbable
* Easy to use

## Example

The example project contains a collection of examples of how to use TweenKit. Run `Example.xcodeproj`

## Installation

TweenKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TweenKit"
```

## How to use

### Import TweenKit

Add `import TweenKit` to the top of the files you want to use TweenKit from

### Creating a scheduler instance

You should create an instance of `Scheduler` to run your animations. You should retain the scheduler, so it's best made as a property on your View Controller.

```
let scheduler = Scheduler()
```

### Actions

TweenKit's animations are comprised of 'Actions'. These are small animation units that can be chained or grouped to build complex animations. Once you have created an action, you can tell the scheduler to run it.

```
scheduler.run(action: myAction)
```

### Animating a view's frame

Anything that conforms to the 'Tweenable' protocol, can be animated.

CGRect, CGFloat, Double, Float, UIColor, and other common objects already adopt the 'Tweenable' out of the box.

We can use TweenKit's `InterpolationAction` to animate a view's frame:

```
let fromRect = CGRect(x: 50, y: 50, width: 100, height: 100)
let toRect = CGRect(x: 200, y: 200, width: 200, height: 70)
        
let action = InterpolationAction(from: fromRect,
                                 to: toRect,
                                 duration: 1.0,
                                 easing: .exponentialInOut,
                                 update: {
        [unowned self] in self.redView.frame = $0
        })

// Tell the scheduler to run the action      
scheduler.run(action: action)
```
!!! Show animation GIF (Basic Tween View Controller) !!!

### Grouping animations

Using `Group`, several animations can be run at once:

```
// Create a move action
let fromRect = CGRect(x: 100, y: 100, width: 50, height: 50)
let toRect = CGRect(x: 200, y: 200, width: 70, height: 70)
        
let move = InterpolationAction(from: fromRect,
                                 to: toRect,
                                 duration: 2.0,
                                 easing: .elasticOut) {
                                    [unowned self] in
                                    self.squareView.frame = $0
}
        
// Create a color change action
let changeColor = InterpolationAction(from: UIColor.red,
                                      to: UIColor.orange,
                                      duration: 2.0,
                                      easing: .exponentialOut) {
                                        [unowned self] in self.squareView.backgroundColor = $0
}
        
// Make a group to run them at the same time
let moveAndChangeColor = Group(actions: move, changeColor)
scheduler.run(action: moveAndChangeColor)
```

!!! Groups GIF !!!

### Running animations in sequence

Using `Sequence`, several animations can be run in order. This time, we can use supply a closure as the 'from' parameter, to animate the view from it's current frame:

```
let moveOne = InterpolationAction(from: { [unowned self] in self.squareView.frame },
                                  to: CGRect(x: 200, y: 150, width: 50, height: 50),
                                  duration: 1,
                                  easing: .exponentialInOut) {
                                  [unowned self] in self.squareView.frame = $0
}
        
let moveTwo = InterpolationAction(from: { [unowned self] in self.squareView.frame },
                                  to: CGRect(x: 150, y: 220, width: 130, height: 130),
                                  duration: 1,
                                  easing: .exponentialInOut) {
                                  [unowned self] in self.squareView.frame = $0
}
        
let moveTwice = Sequence(actions: moveOne, moveTwo)
scheduler.run(action: moveTwice)
```

!!! GIF !!!

### Repeating actions

Use `RepeatAction` to repeat your actions, or `RepeatForeverAction` to repeat an action forever. You can easily contruct these using the `repeated(times:)` and `repeatedForever` methods on any action:

```
let repeatedForever = myAction.repeatedForever()
scheduler.run(action: repeatedForever)
```

### Yoyo

If you want your action to go back and forth, you can use the `Yoyo` action:

```
let move = InterpolationAction(from: { [unowned self] in self.squareView.frame },
                               to: CGRect(x: 250, y: 100, width: 100, height: 100),
                               duration: 1,
                               easing: .exponentialInOut) {
                                [unowned self] in self.squareView.frame = $0
}
        
scheduler.run(action: move.yoyo().repeatedForever() )
```
!!! Yoyo GIF !!!

### Bezier Actions

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

### Scrubbable actions

Scrubbable Actions are great for building unique onboarding experiences.

Instead of adding the action to a scheduler, create an `ActionScrubber` instance:

```     
let move = InterpolationAction(from: { [unowned self] in self.squareView.frame },
                               to: CGRect(x: 250, y: 100, width: 100, height: 100),
                               duration: 1,
                               easing: .sineInOut) {
                               [unowned self] in self.squareView.frame = $0
}
        
self.actionScrubber = ActionScrubber(action: move)

// Update the action scrubber on slider changed callback 
func sliderChanged(slider: UISlider) {
    actionScrubber.update(t: Double(slider.value))
}

```

### Animating your own objects

By adding conformance to the `Tweenable` protocol, anything can be animated. You decide what it means to 'tween' your object, making this a flexible approach.

For instance, by conforming `String` to `Tweenable` we can change a **bat** into a **cat**:

![battocat](https://cloud.githubusercontent.com/assets/6288713/24763350/04d6c82e-1ae9-11e7-9aa8-d0ec97cdd8f1.gif)

### Other Stuff

Use `DelayAction` to add a delay in to a sequence

Use `CallBlockAction` to trigger a callback at any point in a sequence

## Author

Steve Barnegren

steve.barnegren@gmail.com

@stevebarnegren

## License

TweenKit is available under the MIT license. See the LICENSE file for more info.
