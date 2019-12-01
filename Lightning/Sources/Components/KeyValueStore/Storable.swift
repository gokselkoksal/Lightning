//
//  Storable.swift
//  Lightning
//
//  Created by Göksel Köksal on 30.11.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

/// Any value that is storable in a key value store.
public protocol Storable {
  associatedtype RawValue
  
  var rawValue: RawValue { get }
  init?(rawValue: RawValue)
}

// MARK: - Storable + Optional

extension Optional: Storable where Wrapped: Storable {
  
  public typealias RawValue = Optional<Wrapped.RawValue>
  
  public init?(rawValue: Optional<Wrapped.RawValue>) {
    guard let rawValue = rawValue else { return nil }
    self = Wrapped(rawValue: rawValue)
  }
  
  public var rawValue: Optional<Wrapped.RawValue> {
    return self?.rawValue
  }
}

// MARK: - Storable + Array

extension Array: Storable where Element: Storable {
  
  public var rawValue: [Element.RawValue] {
    return map({ $0.rawValue })
  }
  
  public init?(rawValue: RawValue) {
    let value = rawValue.compactMap({ Element(rawValue: $0) })
    guard value.count == rawValue.count else { return nil }
    self = value
  }
}

// MARK: - Storable + Dictionary

extension Dictionary: Storable where Key: Storable, Value: Storable, Key.RawValue: Hashable {
  
  public var rawValue: [Key.RawValue: Value.RawValue] {
    var rawDictionary: [Key.RawValue: Value.RawValue] = [:]
    for (key, value) in self {
      rawDictionary[key.rawValue] = value.rawValue
    }
    return rawDictionary
  }
  
  public init?(rawValue rawDictionary: [Key.RawValue: Value.RawValue]) {
    var dictionary: [Key: Value] = [:]
    
    for (rawKey, rawValue) in rawDictionary {
      guard let key = Key(rawValue: rawKey) else { return nil }
      guard let value = Value(rawValue: rawValue) else { return nil }
      dictionary[key] = value
    }
    
    self = dictionary
  }
}

// MARK: - Storable + Primitives

public protocol StorablePrimitive: Storable { }

public extension StorablePrimitive {
  
  var rawValue: Self {
    return self
  }
  
  init?(rawValue: Self) {
    self = rawValue
  }
}

extension Data: StorablePrimitive { }
extension String: StorablePrimitive { }
extension Date: StorablePrimitive { }
extension NSNumber: StorablePrimitive { }
extension Int: StorablePrimitive { }
extension UInt: StorablePrimitive { }
extension Double: StorablePrimitive { }
extension Float: StorablePrimitive { }
extension Bool: StorablePrimitive { }

// MARK: - Storable + URL

extension URL: Storable {
  
  public var rawValue: String {
    return absoluteString
  }
  
  public init?(rawValue: String) {
    self.init(string: rawValue)
  }
}

// MARK: - Storable + Codable

public protocol StorableCodable: Codable, Storable {
  static var storeEncoder: JSONEncoder { get }
  static var storeDecoder: JSONDecoder { get }
}

extension StorableCodable {
  
  public static var storeEncoder: JSONEncoder {
    return JSONEncoder()
  }
  
  public static var storeDecoder: JSONDecoder {
    return JSONDecoder()
  }
  
  public var rawValue: Data {
    do {
      return try Self.storeEncoder.encode(self)
    } catch {
      fatalError("[Codable+Storable] Encoding failed on object of type \(type(of: self))")
    }
  }
  
  public init?(rawValue: Data) {
    guard let value = try? Self.storeDecoder.decode(Self.self, from: rawValue) else {
      return nil
    }
    self = value
  }
}
