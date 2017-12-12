//
//  Protected.swift
//  Lightning
//
//  Created by Göksel Köksal on 21/11/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

public class Protected<Value> {
    
    private var queue = DispatchQueue(label: "me.gk.Lightning.Protected", attributes: .concurrent)
    private var _value: Value
    
    public var value: Value {
        get {
            var safeValue: Value?
            queue.sync {
                safeValue = _value
            }
            return safeValue!
        }
        set {
            queue.async(flags: .barrier) { [weak self] in
                self?._value = newValue
            }
        }
    }
    
    public init(_ value: Value) {
        _value = value
    }
    
    public func read(_ block: (Value) -> Void) {
        queue.sync {
            block(_value)
        }
    }
    
    public func write(_ block: @escaping (inout Value) -> Void) {
        queue.async(flags: .barrier) { [weak self] in
            guard let strongSelf = self else { return }
            block(&strongSelf._value)
        }
    }
}
