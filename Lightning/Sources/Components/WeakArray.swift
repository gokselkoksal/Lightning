//
//  WeakArray.swift
//  Lightning
//
//  Created by Göksel Köksal on 22/11/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

/// Array to keep elements weakly.
public struct WeakArray<Element: AnyObject> {
    
    /// Array of weak elements.
    public private(set) var weakElements: [Weak<Element>] = []
    
    /// Array of non-nil elements.
    public var elements: [Element] {
        return weakElements.compactMap { $0.value }
    }
    
    /// Creates a weak array with given elements.
    ///
    /// - Parameter elements: Initial elements.
    public init(elements: [Element] = []) {
        for element in elements {
            appendWeak(element)
        }
    }
    
    /// Wraps given object in `Weak` struct and appends it to `weakElements`.
    ///
    /// - Parameter object: Object to append weakly.
    public mutating func appendWeak(_ object: Element?) {
        guard let object = object else { return }
        weakElements.append(Weak(object))
    }
    
    /// Removes all wrappers.
    public mutating func removeAll() {
        weakElements.removeAll()
    }
    
    /// Removes wrappers with nil values from elements.
    public mutating func compact() {
        let indexesToDelete = NSMutableIndexSet()
        for (index, weakObject) in weakElements.enumerated() {
            if weakObject.value == nil {
                indexesToDelete.add(index)
            }
        }
        for index in indexesToDelete {
            weakElements.remove(at: index)
        }
    }
}
