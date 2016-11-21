# Lightning
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Language](https://img.shields.io/badge/swift-3.0-orange.svg)](http://swift.org)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/gokselkoksal/Lightning/blob/master/LICENSE.txt)

Lightning provides components to make Swift development easier.

## Components

### Result
```swift
public enum Result<Value> {
    case success(Value)
    case failure(Error)
}
```
Boxes result of a task with `success` and `failure` cases. Also defines `map` and `flatMap` functions for easy transformation between different types.

### ActivityState
Component to track live activities. Mostly used to show/hide loading view as in the following example.

```swift
var activityState = ActivityState() {
    didSet {
        guard activityState.isToggled else { return }
        if activityState.isActive {
            // Show loading view.
        } else {
            // Hide loading view.
        }
    }
}

func someProcess() {
    activityState.add()
    asyncCall1() {
        // ...
        activityState.add()
        asyncCall2() {
            // ...
            activityState.remove()
        }
        activityState.remove()
    }
}
```
### CollectionChange
```swift
public enum CollectionChange {
    case reload
    case update(IndexSetConvertible)
    case insertion(IndexSetConvertible)
    case deletion(IndexSetConvertible)
    case move(from: Int, to: Int)
}
```
Enum to encapsulate change in any collection. Can be used to model `UITableView`/`UICollectionView` or any `CollectionType` changes.

### TaskState
```swift
public struct TaskState<Value> {   
    public private(set) var status: TaskStatus = .idle // inProgress, cancelled, finished
    public private(set) var result: Result<Value>?
    public private(set) var latestValue: Value?
}
```
Component to model a task through its lifecycle. This can be useful if you have multiple tasks to track separately as in the following example.
```swift
var currencyTask: TaskState<Currency> {
    didSet {
        // Update currency widget. (Show/hide loading view, show error, show result etc.)
    }
}
var weatherTask: TaskState<Weather> {
    didSet {
        // Update weather widget. (Show/hide loading view, show error, show result etc.)
    }
}
```

## Installation
### Carthage
```
github "gokselkoksal/Lightning"
```

## TODO
- [ ] Support CocoaPods.

## License
Lightning is available under the [MIT license](https://github.com/gokselkoksal/Lightning/blob/master/LICENSE.txt).
