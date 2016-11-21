//
//  Protected.swift
//  Lightning
//
//  Created by Göksel Köksal on 21/11/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

struct Protected<Value> {
    
    private var queue = DispatchQueue(label: "me.gk.Lightning.Protected")
    private var _value: Value
    
    var value: Value {
        get {
            var safeValue: Value?
            queue.sync {
                safeValue = _value
            }
            return safeValue!
        }
        set {
            queue.sync {
                _value = newValue
            }
        }
    }
    
    init(_ value: Value) {
        _value = value
    }
    
    mutating func read(_ block: (Value) -> Void) {
        block(value)
    }
    
    mutating func write(_ block: (Value) -> Value) {
        value = block(value)
    }
}
