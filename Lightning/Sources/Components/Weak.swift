//
//  Weak.swift
//  Lightning
//
//  Created by Göksel Köksal on 22/11/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

/// Wrapper struct to reference objects weakly.
public struct Weak<Value: AnyObject> {
    
    /// Wrapped object.
    public weak var value: Value?
    
    /// Creates a weak object wrapper.
    ///
    /// - Parameter value: Object to wrap.
    public init(_ value: Value?) {
        self.value = value
    }
}
