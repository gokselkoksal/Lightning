//
//  Atomic.swift
//  Lightning
//
//  Created by Göksel Köksal on 21/11/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

/// A value register to read/write with locking.
public final class Atomic<Value> {
  
  private var queue = DispatchQueue(label: "me.gk.Lightning.Atomic", attributes: .concurrent)
  private var _value: Value
  
  /// Current value.
  public var value: Value {
    get {
      return queue.sync { _value }
    }
    set {
      queue.async(flags: .barrier) { [weak self] in
        self?._value = newValue
      }
    }
  }
  
  /// Creates a protected instance.
  ///
  /// - Parameter value: Value to wrap.
  public init(_ value: Value) {
    _value = value
  }
  
  /// Performs given block synchronously with the current value while locking.
  ///
  /// - Parameter block: Read block.
  public func read(_ work: (Value) -> Void) {
    syncRead(work)
  }
  
  /// Performs given block asynchronously with the reference of the current value while locking.
  ///
  /// - Parameter block: Read/write block.
  public func write(_ work: @escaping (inout Value) -> Void) {
    asyncWrite(work)
  }
}

// MARK: - Advanced

public extension Atomic {
  
  // MARK: Read
  
  public func syncRead(_ work: ((Value) throws -> Void)) rethrows {
    try queue.sync {
      try work(_value)
    }
  }
  
  public func syncRead<T>(_ work: ((Value) throws -> T)) rethrows -> T {
    return try queue.sync {
      return try work(_value)
    }
  }
  
  public func asyncRead(_ work: @escaping ((Value) -> Void)) {
    return queue.async { [weak self] in
      guard let self = self else { return }
      work(self._value)
    }
  }
  
  // MARK: Write
  
  public func syncWrite(_ work: (inout Value) throws -> Void) rethrows {
    try queue.sync(flags: .barrier) {
      try work(&_value)
    }
  }
  
  public func syncWrite<T>(_ work: (inout Value) throws -> T) rethrows -> T {
    return try queue.sync(flags: .barrier) {
      return try work(&_value)
    }
  }
  
  public func asyncWrite(_ work: @escaping (inout Value) -> Void) {
    queue.async(flags: .barrier) { [weak self] in
      guard let self = self else { return }
      work(&self._value)
    }
  }
}
