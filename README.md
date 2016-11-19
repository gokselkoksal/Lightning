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
var loadingState = ActivityTracker() {
    didSet {
        if loadingState.isToggled {
            if loadingState.isActive {
                // Show loading view.
            } else {
                // Hide loading view.
            }
        }
    }
}

func someProcess() {
    loadingState.add()
    asyncCall1() {
        // ...
        loadingState.add()
        asyncCall2() {
            // ...
            loadingState.remove()
        }
        loadingState.remove()
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
