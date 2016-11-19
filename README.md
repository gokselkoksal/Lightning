# Lightning

Lightning provides components to make development easier. (Swift 3)

## Components

### Result

Boxes result of a task with `success` and `failure` cases.

```
public enum Result<Value> {
    case success(Value)
    case failure(Error)
}
```
`map` and `flatMap` functions are also provided for easy transformation.
