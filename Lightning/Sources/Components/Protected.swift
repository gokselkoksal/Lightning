//
//  Protected.swift
//  Lightning
//
//  Created by Göksel Köksal on 21/11/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

/// A value register to read/write with locking.
public class Protected<Value> {
    
    /// Operation mode for transactions.
    ///
    /// - sync: Read/write synchronously.
    /// - async: Read/write asynchronously using barrier.
    public enum OperationMode {
        case sync
        case async
    }
    
    private var queue = DispatchQueue(label: "me.gk.Lightning.Protected", attributes: .concurrent)
    private var _value: Value
    
    /// Current value.
    public var value: Value {
        get {
            return queue.sync { _value }
        }
        set {
            queue.async(flags: .barrier) { [weak self] in
                self?._value = newValue
            }
        }
    }
    
    /// Creates a protected instance.
    ///
    /// - Parameter value: Value to wrap.
    public init(_ value: Value) {
        _value = value
    }
    
    /// Calls given block synchronously with the current value while locking.
    ///
    /// - Parameter block: Read block.
    public func read(_ block: (Value) -> Void) {
        queue.sync {
            block(_value)
        }
    }
    
    /// Calls given block with a reference (inout) to the current value while locking.
    ///
    /// - Parameters:
    ///   - mode: Write mode. `async` by default.
    ///   - block: Read/write block.
    public func write(mode: OperationMode = .async, _ block: @escaping (inout Value) -> Void) {
        let execution: () -> Void = { [weak self] in
            guard let strongSelf = self else { return }
            block(&strongSelf._value)
        }
        
        switch mode {
        case .async:
            queue.async(flags: .barrier, execute: execution)
        case .sync:
            queue.sync(execute: execution)
        }
    }
}
