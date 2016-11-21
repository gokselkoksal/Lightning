# Lightning

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
        if activityState.isToggled {
            if activityState.isActive {
                // Show loading view.
            } else {
                // Hide loading view.
            }
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
