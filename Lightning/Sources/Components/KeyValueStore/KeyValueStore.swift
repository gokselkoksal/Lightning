//
//  KeyValueStore.swift
//  Lightning
//
//  Created by Göksel Köksal on 20.11.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

/// A string key with name and corresponding value type.
public typealias ValueKey<Value: Storable> = CustomValueKey<String, Value>

/// A key with name and corresponding value type.
public final class CustomValueKey<Key, Value: Storable> {
  
  /// Name of the key.
  public let name: Key
  
  /// Corresponding value type.
  public let valueType: Value.Type
  
  public init(_ name: Key) {
    self.name = name
    self.valueType = Value.self
  }
}

/// Store that keeps associated key value pairs.
public protocol KeyValueStore: class {
  associatedtype Key
  
  func set<Value: Storable>(_ value: Value?, for key: CustomValueKey<Key, Value>)
  func value<Value: Storable>(for key: CustomValueKey<Key, Value>) -> Value?
}
