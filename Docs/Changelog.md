# Changelog

## Version 3.0.0

* Moved `Channel` into its own framework [Rasat](https://www.github.com/gokselkoksal/Rasat).
  * New vs. old API:

```swift
// Version 2.x:
channel.subscribe(self) { event in
  // Handle event...
}

// Version 3.0:
disposeBag += channel.observable.subscribe(self) { message in
  // Handle message here.
}
```

* `Protected` is renamed to `Atomic` as it's a commonly used term for the job done.
  * Removed `OperationMode` enum from `write(...)` function.
  * Extended functionality:

```swift
let count = Atomic<Int>(0)
// Read:
count.syncRead   { print($0) } // Identical to count.read { ... }
count.asyncRead  { print($0) }
// Write:
count.syncWrite  { $0 += 1 }
count.asyncWrite { $0 += 1 }   // Identical to count.write { ... }
```

* `Weak` is now a `class` instead of being a `struct`. There's no advantage of value semantics here.

* Removed `TaskState` as it didn't prove to be useful/generic enough to be a part of this framework. You can still manually add it to your project from 2.0.0 tag.

* Removed `Bounds`. Use `Range` API instead.

```swift
let bounds = Bounds(.inclusive(2), .exclusive(5))
// is equivalent to:
let bounds = 2..<5
```

* Removed `IndexSetConvertible` protocol to further simplify `CollectionChange` implementation. 

* Reworked `TimerController` API. 
  * It is now possible to inject a ticker that conforms to `TickerProtocol`. Handy for unit testing.
  * Tick handler is moved from `init(...)` to `startTimer(...)` function. 

```swift
let ticker = Ticker() // or MockTicker()
let timerController = TimerController(total: 60.0, ticker: ticker)
timerController.startTimer {
  timerLabel.text = "\(state.remaining) seconds remaining..."
}
```

* Removed redundant `Formatter` protocol. `StringFormatter` no longer conforms to it. 
