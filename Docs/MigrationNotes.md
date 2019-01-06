
# Migration Notes

## From 2.X.X to 3.0.0

* Moved `Channel` into its own framework [Rasat](https://www.github.com/gokselkoksal/Rasat).

Old API:

```swift
channel.subscribe(self) { event in
  // Handle event...
}
```

New API:

```swift
disposeBag += channel.observable.subscribe(self) { message in
  // Handle message here.
}
```

For more: [Rasat](https://www.github.com/gokselkoksal/Rasat) 

* `Weak` is now a `class` instead of being a `struct`. There's no advantage of value semantics here.

* Removed `TaskState` as it's not generic enough. You can still manually add it to your project from 2.0.0 tag.

* Removed `Bounds`. Use `Range` API instead.

```
let bounds = Bounds(.inclusive(2), .exclusive(5))
// is equivalent to:
let bounds = 2..<5
```

* Removed `IndexSetConvertible` protocol to further simplify `CollectionChange` implementation. 

* Reworked `TimerController` API. It is now possible to inject a ticker. Tick handler is moved from `init(...)` to `startTimer(...)` function. 

```swift
let ticker = Ticker() // or MockTicker()
let timerController = TimerController(total: 60.0, ticker: ticker)
timerController.startTimer {
  timerLabel.text = "\(state.remaining) seconds remaining..."
}
```
