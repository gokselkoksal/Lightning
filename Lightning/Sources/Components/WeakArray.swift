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
  public var weakElements: [Weak<Element>]
  
  /// Creates a weak array with given elements.
  ///
  /// - Parameter elements: Initial elements.
  public init(elements: [Element] = []) {
    weakElements = elements.map({ Weak($0) })
  }
  
  /// Wraps given object in `Weak` struct and appends it to `weakElements`.
  ///
  /// - Parameter object: Object to append weakly.
  public mutating func append(_ object: Element?) {
    guard let object = object else { return }
    weakElements.append(Weak(object))
  }
  
  /// Removes wrappers with nil values from elements.
  public mutating func compact() {
    weakElements = weakElements.filter({ $0.value != nil })
  }
  
  /// Reads elements stored in weak array.
  ///
  /// - Returns: Strong references to the elements.
  public func strongElements() -> [Element] {
    return weakElements.compactMap({ $0.value })
  }
}
