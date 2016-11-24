# Lightning
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Language](https://img.shields.io/badge/swift-3.0-orange.svg)](http://swift.org)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/gokselkoksal/Lightning/blob/master/LICENSE.txt)

Lightning provides components to make Swift development easier.

## Installation
Using [Carthage](https://github.com/Carthage/Carthage):
```
github "gokselkoksal/Lightning"
```
Using [CocoaPods](https://github.com/CocoaPods/CocoaPods):
```
pod 'Lightning'
```
## Components

### Result
```swift
public enum Result<Value> {
    case success(Value)
    case failure(Error)
}
```
Boxes result of a task with `success` and `failure` cases. Also defines `map` and `flatMap` functions for easy transformation between different types.

### Protected
`Protected` is a thread safe wrapper around values.
```swift
var list = Protected(["item1"])

// Get value:
let items = list.value

// Set value:
list.value = ["item1", "item2"]

// Read block:
list.read { items in
    // Process...
}

// Write block:
list.write { items in
    // Process...
    return updatedItems
}
```

### Weak & WeakArray
- `Weak` is a wrapper to reference an object weakly.
- `WeakArray` is an `Array` that references its elements weakly. (Similar to `NSPointerArray`.)

Following example shows how it can be used for request cancelling.

```swift
var liveRequests = WeakArray<URLSessionTask>()

func viewDidLoad() {
    super.viewDidLoad()
    // Following async requests will be live until we get a response from server.
    // Keep a weak reference to each to be able to cancel when necessary.
    let offersRequest = viewModel.getOffers { ... }
    liveRequests.appendWeak(offersRequest)
    let favoritesRequest = viewModel.getFavorites { ... }
    liveRequests.appendWeak(favoritesRequest)
}

func viewWillDisappear() {
    super.viewWillDisappear()
    liveRequests.elements.forEach { $0.cancel() }
    liveRequests.removeAll()
}
```

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

## License
Lightning is available under the [MIT license](https://github.com/gokselkoksal/Lightning/blob/master/LICENSE.txt).
