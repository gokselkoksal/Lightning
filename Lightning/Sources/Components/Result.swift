//
//  Result.swift
//  Lightning
//
//  Created by Göksel Köksal on 19/11/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

public enum Result<Value> {
    case success(Value)
    case failure(Error)
}

public extension Result {

    public var isSuccess: Bool {
        switch self {
        case .success(_):
            return true
        case .failure(_):
            return false
        }
    }
    
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure(_):
            return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .success(_):
            return nil
        case .failure(let error):
            return error
        }
    }
}

public extension Result {
    
    public func map<T>(_ transform: (Value) -> T) -> Result<T> {
        switch self {
        case .success(let value):
            let newValue = transform(value)
            return Result<T>.success(newValue)
        case .failure(let error):
            return Result<T>.failure(error)
        }
    }
    
    public func flatMap<T>(_ transform: (Value) -> Result<T>) -> Result<T> {
        switch self {
        case .success(let value):
            return transform(value)
        case .failure(let error):
            return Result<T>.failure(error)
        }
    }
}

public extension Result where Value == Void {
    static var success: Result<Void> = Result<Void>.success(())
}
