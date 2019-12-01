//
//  StoredWrapperTests.swift
//  Lightning
//
//  Created by Göksel Köksal on 21.11.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import XCTest
import Lightning

class KeyValueStoreTests: XCTestCase {
  
  private var userDefaults: UserDefaults!
  private var inMemoryStore: InMemoryKeyValueStore<String>!
  
  private let data = RandomTestData()
  
  override func setUp() {
    userDefaults = UserDefaults(suiteName: "KeyValueStoreTests")
    inMemoryStore = InMemoryKeyValueStore<String>()
  }
  
  override func tearDown() {
    userDefaults.removePersistentDomain(forName: "KeyValueStoreTests")
  }
  
  func testUserDefaults() throws {
    try userDefaults.assert(with: data)
  }
  
  func testInMemoryStore() throws {
    try userDefaults.assert(with: data)
  }
}

// MARK: - Helpers

private enum Keys {
  static let data = ValueKey<Data>("data")
  static let string = ValueKey<String>("string")
  static let date = ValueKey<Date>("date")
  static let number = ValueKey<NSNumber>("number")
  static let int = ValueKey<Int>("int")
  static let uint = ValueKey<UInt>("uint")
  static let double = ValueKey<Double>("double")
  static let float = ValueKey<Float>("float")
  static let bool = ValueKey<Bool>("bool")
  static let array = ValueKey<[UInt]>("array")
  static let dictionary = ValueKey<[String: Int]>("dictionary")
}

private extension KeyValueStore where Key == String {
  
  func assert(with data: RandomTestData, file: StaticString = #file, line: UInt = #line) throws {
    assertValue(at: Keys.data, with: data.data, file: file, line: line)
    assertValue(at: Keys.string, with: data.string, file: file, line: line)
    assertValue(at: Keys.date, with: data.date, file: file, line: line)
    assertValue(at: Keys.number, with: data.number, file: file, line: line)
    assertValue(at: Keys.int, with: data.int, file: file, line: line)
    assertValue(at: Keys.uint, with: data.uint, file: file, line: line)
    try assertFloatingPoint(at: Keys.double, with: data.double, accuracy: epsilon.doubleValue, file: file, line: line)
    try assertFloatingPoint(at: Keys.float, with: data.float, accuracy: epsilon.floatValue, file: file, line: line)
    assertValue(at: Keys.bool, with: data.bool, file: file, line: line)
    assertValue(at: Keys.array, with: data.array, file: file, line: line)
    assertValue(at: Keys.dictionary, with: data.dictionary, file: file, line: line)
  }
  
  func assertNonNilValue<T: Equatable & Storable>(
    at key: CustomValueKey<Key, T>,
    with value: T,
    defaultValue: T,
    file: StaticString = #file,
    line: UInt = #line)
  {
    XCTAssertEqual(self.value(for: key), defaultValue, file: file, line: line)
    self.set(value, for: key)
    XCTAssertEqual(self.value(for: key), value, file: file, line: line)
  }
  
  func assertValue<T: Equatable>(
    at key: CustomValueKey<Key, T>,
    with value: T?,
    file: StaticString = #file,
    line: UInt = #line)
  {
    XCTAssertNil(self.value(for: key), file: file, line: line)
    self.set(value, for: key)
    XCTAssertEqual(self.value(for: key), value, file: file, line: line)
  }
  
  func assertFloatingPoint<T: FloatingPoint>(
    at key: CustomValueKey<Key, T>,
    with value: T?,
    accuracy: T,
    file: StaticString = #file,
    line: UInt = #line) throws
  {
    XCTAssertNil(self.value(for: key), file: file, line: line)
    self.set(value, for: key)
    XCTAssertEqual(try self.value(for: key).unwrap(), try value.unwrap(), accuracy: accuracy, file: file, line: line)
  }
}
