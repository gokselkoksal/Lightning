# Lightning :zap:

[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/Lightning.svg?style=flat)](http://cocoapods.org/pods/Lightning)
[![CI Status](http://img.shields.io/travis/gokselkoksal/Lightning.svg?style=flat)](https://travis-ci.org/gokselkoksal/Lightning)
[![Platform](https://img.shields.io/cocoapods/p/Lightning.svg?style=flat)](http://cocoadocs.org/docsets/Lightning)
[![Language](https://img.shields.io/badge/swift-4.0-orange.svg)](http://swift.org)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/gokselkoksal/Lightning/blob/master/LICENSE.txt)

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

### Channel

A simple event bus implementation for Swift. See this article for more: [Using Channels for Data Flow in Swift](https://medium.com/@gokselkoksal/using-channels-for-data-flow-in-swift-14bbdf27b471)

```swift
enum Message {
  case didUpdateTheme(Theme)
}

let settingsChannel = Channel<Message>()

class SomeView {

  func load() {
    settingsChannel.subscribe(self) { message in
      // React to the message here.
    }
  }
}

let view = SomeView()
view.load()

settingsChannel.broadcast(.didUpdateTheme(.light))
```

See [this gist](https://gist.github.com/gokselkoksal/4ab590f24305e072a547af46d81c056e) for a real-life example.

### StringFormatter & StringMask
Component to format and mask strings with pre-defined patterns.

- Format phone number:
```swift
// Perform 05308808080 -> 0 (530) 880 80 80

let phoneFormatter = StringFormatter(pattern: "# (###) ### ## ##")
let formattedNumber = phoneFormatter.format("05308808080") // Returns "0 (530) 880 80 80"
```
- Mask & format card number:
```swift
// Perform 1111222233334444 -> **** **** 3333 4444

let cardFormatter = StringFormatter("#### #### #### ####")
let cardMask = StringMask(ranges: [NSRange(location: 0, length: 8)])
let cardMaskStorage = StringMaskStorage(mask: mask)

let cardNo = cardNoLabel.text // Equals to "1111222233334444"
cardMaskStorage.original = cardNo
let maskedCardNo = cardMaskStorage.masked // Equals to "********33334444"
let formattedCardNo = cardFormatter.format(maskedCardNo)
cardNoLabel.text = formattedCardNo // Equals to "**** **** 3333 4444"
```

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
    print(items)
}

// Write block:
list.write { items in
    items.append(...)
}
```

### TimerController
`TimerController` is a wrapper around `Timer`, which makes it easy to implement countdowns.
```swift
let timerController = TimerController(total: 60.0) { state in
    timerLabel.text = "\(state.remaining) seconds remaining..."
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
    case update(IndexPathSetConvertible)
    case insertion(IndexPathSetConvertible)
    case deletion(IndexPathSetConvertible)
    case move(from: IndexPathConvertible, to: IndexPathConvertible)
}
```
Enum to encapsulate change in any collection. Can be used to model `UITableView`/`UICollectionView` or any `CollectionType` changes.

```swift
func addCustomer(_ customer: Customer) -> CollectionChange {
    customers.insert(customer, at: 0)
    return .insertion(0)
}
```

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

### Bounds

```swift
let bounds = Bounds(.inclusive(2), .exclusive(5))
// A successful test:
XCTAssertFalse(bounds.contains(0))
XCTAssertFalse(bounds.contains(1))
XCTAssertTrue(bounds.contains(2))
XCTAssertTrue(bounds.contains(3))
XCTAssertTrue(bounds.contains(4))
XCTAssertFalse(bounds.contains(5))
XCTAssertFalse(bounds.contains(6))
```

## Extensions
Lightning provides extensions on known types with `zap` :zap: prefix.

### String+Helpers
```swift
let string = "Welcome"

// Int -> String.Index conversion:
let index1 = string.zap_index(1)
let eChar = string[index1] // "e"
let eChar = string.zap_character(at: 1) // "e"

// NSRange -> Range<String.Index> conversion:
let nsRange = NSRange(location: 0, length: 3)
let substring = string.zap_substring(with: nsRange) // "Wel"
let stringRange = string.zap_range(from: nsRange)
let substring = string.substring(with: stringRange) // "Wel"

// Range validation for NSRange -> Range<String.Index>:
let shortString = "Go"
let intersectedRange = shortString.zap_rangeIntersection(with: nsRange)
// `nsRange` [0, 2] is out of bounds for "Go". Intersection is [0, 1].
```

### Dictionary+Helpers
Introduces `+` and `+=` operators.
```swift
let dict1 = ["k1": "v1", "k2": "v2"]
let dict2 = ["k3": "v3"]
var dict3 = dict1 + dict2 // [(k1: v1), (k2: v2), (k3: v3)]
dict3 += ["k4": "v4"]     // [(k1: v1), (k2: v2), (k3: v3), (k4: v4)]
dict3 += ["k4": "xx"]     // [(k1: v1), (k2: v2), (k3: v3), (k4: xx)]
```

### Bundle+Helpers
Provides version string helpers.
```swift
// Version field:
bundle.zap_shortVersionString // 1.2.1

// Build field:
bundle.zap_versionString      // 345
```

## Installation

### Using [CocoaPods](https://github.com/CocoaPods/CocoaPods)
Add the following line to your `Podfile`:
```
pod 'Lightning'
```

### Using [Carthage](https://github.com/Carthage/Carthage)
Add the following line to your `Cartfile`:
```
github "gokselkoksal/Lightning"
```

### Manually
Drag and drop `Sources` folder to your project. 

*It's highly recommended to use a dependency manager like `CocoaPods` or `Carthage`.*

## License
Lightning is available under the [MIT license](https://github.com/gokselkoksal/Lightning/blob/master/LICENSE.txt).
