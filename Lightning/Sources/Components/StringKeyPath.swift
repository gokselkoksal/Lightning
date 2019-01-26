//
//  StringKeyPath.swift
//  Lightning
//
//  Created by Göksel Köksal on 26.01.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

public struct StringKeyPath {
  
  public let value: String
  public let components: [String]
  public let delimeter: String
  
  public var firstKey: String {
    return components.first!
  }
  
  public var lastKey: String {
    return components.last!
  }
  
  public var isLeaf: Bool {
    return components.count == 1
  }
  
  public func dropFirstKey() -> StringKeyPath? {
    guard isLeaf == false else { return nil }
    let value = components.dropFirst().joined(separator: delimeter)
    return StringKeyPath(value, delimeter: delimeter)
  }
  
  public init(_ value: String, delimeter: String = ".") {
    precondition(value.count > 0, "[StringKeyPath] Key path cannot be empty.")
    let components = value.components(separatedBy: delimeter)
    
    self.value = value
    self.components = components
    self.delimeter = delimeter
  }
}

// MARK: - Convenience

extension StringKeyPath: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self.init(value)
  }
}

// MARK: - StringKeyPath + ValueKey + Dictionary

public extension Dictionary where Key == String {
  
  subscript(keyPath keyPath: StringKeyPath) -> Value? {
    if keyPath.isLeaf {
      return self[keyPath.value]
    } else {
      guard let next = self[keyPath.firstKey] as? [Key: Value],
        let nextKeyPath = keyPath.dropFirstKey()
        else { return nil }
      return next[keyPath: nextKeyPath]
    }
  }
  
  subscript<T>(key: CustomValueKey<Key, T>) -> T? {
    return self[key, delimeter: "."]
  }
  
  subscript<T>(key: CustomValueKey<Key, T>, delimeter delimeter: String) -> T? {
    let keyPath = StringKeyPath(key.name, delimeter: delimeter)
    return self[keyPath: keyPath] as? T
  }
}
