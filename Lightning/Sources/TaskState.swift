//
//  TaskState.swift
//  Lightning
//
//  Created by Göksel Köksal on 19/11/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

public enum TaskStatus {
    case idle
    case inProgress
    case cancelled
    case finished
}

public struct TaskState<Value> {
    
    public private(set) var status: TaskStatus = .idle
    public private(set) var result: Result<Value>?
    public private(set) var latestValue: Value?
    
    public init(value: Value? = nil) {
        guard let value = value else { return }
        self.result = Result.success(value)
        self.latestValue = value
    }
    
    public mutating func setInProgress() {
        status = .inProgress
    }
    
    public mutating func setFinished(with result: Result<Value>) {
        status = .finished
        register(result: result)
    }
    
    public mutating func setCancelled(with result: Result<Value>? = nil) {
        status = .cancelled
        if let result = result {
            register(result: result)
        }
    }
    
    public mutating func reset(with value: Value? = nil) {
        if let value = value {
            self.result = Result.success(value)
        } else {
            self.result = nil
        }
        self.latestValue = value
        self.status = .idle
    }
    
    private mutating func register(result: Result<Value>) {
        self.result = result
        switch result {
        case .success(let value):
            self.latestValue = value
        default:
            break
        }
    }
}
