# Lightning :zap:

[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/Lightning.svg?style=flat)](http://cocoapods.org/pods/Lightning)
[![CI Status](http://img.shields.io/travis/gokselkoksal/Lightning.svg?style=flat)](https://travis-ci.org/gokselkoksal/Lightning)
[![Platform](https://img.shields.io/cocoapods/p/Lightning.svg?style=flat)](http://cocoadocs.org/docsets/Lightning)
[![Language](https://img.shields.io/badge/swift-5.0-orange.svg)](http://swift.org)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/gokselkoksal/Lightning/blob/master/LICENSE)

Lightning provides components to make Swift development easier.

> If you're looking to migrate from an old version, [see releases](https://github.com/gokselkoksal/Lightning/releases).

## Components

### Property Wrapper: @Stored :package:

`Stored` is a property wrapper that read/write values using an internal key-value store.

> Unlike widely used `@UserDefault` property wrapper, `@Stored` can internally use any key-value store that conforms to `KeyValueStoreProtocol`. There are two pre-defined key-value stores in Lightning:
> 
> * `UserDefaults`
> * `InMemoryKeyValueStore`: A key-value store that uses an internal dictionary to store data. Useful when unit-testing.

**Definition:**

```swift
final class UserPreferences {

  @Stored var temperatureUnit: TemperatureUnit?
  @Stored var weightUnit: WeightUnit
  
  // Inject store into wrappers here:
  init<S: KeyValueStoreProtocol>(store: S) where S.Key == String {
    _temperatureUnit = Stored(key: "temperature-unit", store: store)
    _weightUnit = Stored(key: "weight-unit", defaultValue: .grams, store: store)
}
```

**Usage in app target:**

```swift
let store = UserDefaults.standard
let preferences = UserPreferences(store: store)
preferences.temperatureUnit = .celsius
```

**Usage in test target:**

```swift
let store = InMemoryKeyValueStore<String>() // Internally a simple [String: Any] dictionary.
let preferences = UserPreferences(store: store)
preferences.temperatureUnit = .celsius
```

**Supported types:**

* **Primitives**: `Data`, `String`, `Date`, `NSNumber`, `Int`, `UInt`, `Double`, `Float`, `Bool`, `URL`
* **Any `RawRepresentable`**: Conform to `Storable` on any `RawRepresentable` type. No extra implementation needed.
* **Any `Codable`**: Conform to `StorableCodable` on any `Codable` type. No extra implementation needed.
* **Any `Storable`**: Conform to `Storable` protocol and provide custom implementation for your type.

### Channel :tokyo_tower:
Channel is now a part of [Rasat](https://github.com/gokselkoksal/Rasat)!

### StringFormatter :pen:
```swift
// - Perform 05308808080 -> 0 (530) 880 80 80

let phoneFormatter = StringFormatter(pattern: "# (###) ### ## ##")
let formattedNumber = phoneFormatter.format("05308808080") // Returns "0 (530) 880 80 80"
```

### StringMask :see_no_evil:
```swift
// - Perform 1111222233334444 -> ********33334444

let cardMask = StringMask(ranges: [NSRange(location: 0, length: 8)])
let cardMaskStorage = StringMaskStorage(mask: mask)

// 1. Pass it into the storage:
cardMaskStorage.original = "1111222233334444"
// 2. Read masked & unmasked value back:
let cardNo = cardMaskStorage.original     // "1111222233334444"
let maskedCardNo = cardMaskStorage.masked // "********33334444"
```

### Atomic :atom_symbol:
`Atomic` is a thread safe container for values.
```swift
var list = Atomic(["item1"])

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

### TimerController :stopwatch:
`TimerController` is a wrapper around `Timer`, which makes it easy to implement countdowns.
```swift
let ticker = Ticker() // or MockTicker()
let timerController = TimerController(total: 60, interval: 1, ticker: ticker)
timerController.startTimer { state in
  timerLabel.text = "\(state.remaining) seconds remaining..."
}
```

### Weak & WeakArray :card_file_box:
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

### ActivityState :hourglass:
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

### CollectionChange :iphone::calling:
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
Lightning is available under the [MIT license](https://github.com/gokselkoksal/Lightning/blob/master/LICENSE).
