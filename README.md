# Lightning

Lightning provides helper objects to make development easier. (Swift 3)

## Objects

### Result

Boxes result of a task with `success` and `failure` cases.

```
public enum Result<Value> {
    case success(Value)
    case failure(Error)
}
```
`map` and `flatMap` functions are also provided for easy transformation.
