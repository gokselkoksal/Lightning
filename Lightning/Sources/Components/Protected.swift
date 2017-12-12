//
//  Protected.swift
//  Lightning
//
//  Created by Göksel Köksal on 21/11/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

class Protected<Value> {
    
    private var queue = DispatchQueue(label: "me.gk.Lightning.Protected", attributes: .concurrent)
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
            queue.async(flags: .barrier) { [weak self] in
                self?._value = newValue
            }
        }
    }
    
    init(_ value: Value) {
        _value = value
    }
    
    func read(_ block: (Value) -> Void) {
        queue.sync {
            block(_value)
        }
    }
    
    func write(_ block: @escaping (Value) -> Value) {
        queue.async(flags: .barrier) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf._value = block(strongSelf._value)
        }
    }
}
