//
//  KeyValueStore+TypeErasure.swift
//  Lightning
//
//  Created by Göksel Köksal on 20.11.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

public extension KeyValueStore {
  func eraseToAny() -> AnyKeyValueStore<Key> {
    return AnyKeyValueStore(self)
  }
}

public final class AnyKeyValueStore<Key>: KeyValueStore {
  
  private let store: AnyKeyValueStoreBase<Key>
  
  public init<S: KeyValueStore>(_ store: S) where S.Key == Key {
    self.store = AnyKeyValueStoreBox(store)
  }
  
  public func set<Value: Storable>(_ value: Value?, for key: CustomValueKey<Key, Value>) {
    store.set(value, for: key)
  }
  
  public func value<Value: Storable>(for key: CustomValueKey<Key, Value>) -> Value? {
    return store.value(for: key)
  }
}

// MARK: - Type erasure helpers

// ~Base and ~Box is a commonly used pattern for type erasure.

private final class AnyKeyValueStoreBox<S: KeyValueStore>: AnyKeyValueStoreBase<S.Key> {
  
  private var store: S
  
  init(_ store: S) {
    self.store = store
  }
  
  override func set<Value: Storable>(_ value: Value?, for key: CustomValueKey<S.Key, Value>) {
    store.set(value, for: key)
  }
  
  override func value<Value: Storable>(for key: CustomValueKey<S.Key, Value>) -> Value? {
    store.value(for: key)
  }
}

private class AnyKeyValueStoreBase<Key>: KeyValueStore {
  
  func set<Value: Storable>(_ value: Value?, for key: CustomValueKey<Key, Value>) {
    fatalError()
  }
  
  func value<Value: Storable>(for key: CustomValueKey<Key, Value>) -> Value? {
    fatalError()
  }
}
