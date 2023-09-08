//
//  Stored.swift
//  Lightning
//
//  Created by Göksel Köksal on 21.11.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

/// Property wrapper that stores wrapped value in the given key-value store.
public typealias Stored<Value: Storable> = CustomStored<String, Value>

/// Property wrapper that stores wrapped value in the given key-value store.
@propertyWrapper public class CustomStored<Key, Value: Storable> {
  
  /// Key for the store.
  public let key: CustomValueKey<Key, Value>
  
  /// Default value for the key.
  public let defaultValue: Value
  
  private let store: AnyKeyValueStore<Key>
  
  public init<S: KeyValueStore>(
    key: Key,
    defaultValue: Value,
    store: S)
    where S.Key == Key
  {
    self.key = CustomValueKey(key)
    self.defaultValue = defaultValue
    self.store = store.eraseToAny()
  }
  
  public var wrappedValue: Value {
    get {
      return store.value(for: key) ?? defaultValue
    }
    set {
      return store.set(newValue, for: key)
    }
  }
}

// MARK: - CustomStored + DefaultStorable

public protocol DefaultStorable: Storable {
  static var defaultValue: Self { get }
}

extension Optional: DefaultStorable where Wrapped: Storable {
  public static var defaultValue: Optional<Wrapped> {
    return nil
  }
}

public extension CustomStored where Value: DefaultStorable {
  convenience init<S: KeyValueStore>(key: Key, store: S) where S.Key == Key {
    self.init(key: key, defaultValue: Value.defaultValue, store: store)
  }
}
