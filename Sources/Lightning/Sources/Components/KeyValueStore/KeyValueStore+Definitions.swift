//
//  KeyValueStore+Definitions.swift
//  Lightning iOS
//
//  Created by Göksel Köksal on 23.11.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

// MARK: - UserDefaults

extension UserDefaults: KeyValueStore {
  
  public typealias Key = String
  
  public func set<Value: Storable>(_ value: Value?, for key: CustomValueKey<Key, Value>) {
    set(value?.rawValue, forKey: key.name)
  }
  
  public func value<Value: Storable>(for key: CustomValueKey<Key, Value>) -> Value? {
    guard let rawValue = object(forKey: key.name) as? Value.RawValue else { return nil }
    return Value(rawValue: rawValue)
  }
}

// MARK: - InMemoryKeyValueStore

/// A key-value store that saves data using a dictionary.
public final class InMemoryKeyValueStore<Key: Hashable>: KeyValueStore {

  public private(set) var dictionary: [Key: Any] = [:]
  
  public init() { }
  
  public func set<Value: Storable>(_ value: Value?, for key: CustomValueKey<Key, Value>) {
    dictionary[key.name] = value?.rawValue
  }
  
  public func value<Value: Storable>(for key: CustomValueKey<Key, Value>) -> Value? {
    guard let rawValue = dictionary[key.name] as? Value.RawValue else { return nil }
    return Value(rawValue: rawValue)
  }
}
