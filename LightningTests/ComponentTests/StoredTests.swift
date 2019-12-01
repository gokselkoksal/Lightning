//
//  StoredTests.swift
//  Lightning iOS Tests
//
//  Created by Göksel Köksal on 30.11.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import XCTest
import Lightning

final class StoredTests: XCTestCase {
  
  private var defaults: UserDefaults!
  private var userDefaultsPreferences: Preferences!
  private var inMemoryPreferences: Preferences!
  
  private let data = RandomTestData()
  
  override func setUp() {
    defaults = UserDefaults(suiteName: "StoredTests")
    userDefaultsPreferences = Preferences(store: defaults)
    inMemoryPreferences = Preferences(store: InMemoryKeyValueStore<String>())
  }
  
  override func tearDown() {
    defaults.removePersistentDomain(forName: "StoredTests")
  }
  
  func testInMemoryPreferences() throws {
    try inMemoryPreferences.assert(with: data)
  }
  
  func testUserDefaultsPreferences() throws {
    try userDefaultsPreferences.assert(with: data)
  }
}

private extension Preferences {
  
  func assert(with data: RandomTestData, file: StaticString = #file, line: UInt = #line) throws {
    assertValue(at: \Preferences.string, with: data.string, file: file, line: line)
    assertValue(at: \Preferences.date, with: data.date, file: file, line: line)
    assertValue(at: \Preferences.number, with: data.number, file: file, line: line)
    assertValue(at: \Preferences.int, with: data.int, file: file, line: line)
    assertValue(at: \Preferences.uint, with: data.uint, file: file, line: line)
    try assertFloatingPoint(at: \Preferences.double, with: data.double, accuracy: epsilon.doubleValue, file: file, line: line)
    try assertFloatingPoint(at: \Preferences.float, with: data.float, accuracy: epsilon.floatValue, file: file, line: line)
    assertValue(at: \Preferences.bool, with: data.bool, file: file, line: line)
    assertValue(at: \Preferences.url, with: data.url, file: file, line: line)
    assertValue(at: \Preferences.data, with: data.data, file: file, line: line)
    assertValue(at: \Preferences.array, with: data.array, file: file, line: line)
    assertValue(at: \Preferences.dictionary, with: data.dictionary, file: file, line: line)
    assertValue(at: \Preferences.userDetails, with: data.userDetails, file: file, line: line)
    assertValue(at: \Preferences.temperatureUnit, with: data.temperatureUnit, file: file, line: line)
    assertNonNilValue(at: \Preferences.weightUnit, with: .oz, defaultValue: .grams, file: file, line: line)
  }
  
  func assertNonNilValue<T: Equatable>(
    at keyPath: ReferenceWritableKeyPath<Preferences, T>,
    with value: T,
    defaultValue: T,
    file: StaticString = #file,
    line: UInt = #line)
  {
    XCTAssertEqual(self[keyPath: keyPath], defaultValue, file: file, line: line)
    self[keyPath: keyPath] = value
    XCTAssertEqual(self[keyPath: keyPath], value, file: file, line: line)
  }
  
  func assertValue<T: Equatable>(
    at keyPath: ReferenceWritableKeyPath<Preferences, T?>,
    with value: T,
    file: StaticString = #file,
    line: UInt = #line)
  {
    XCTAssertNil(self[keyPath: keyPath], file: file, line: line)
    self[keyPath: keyPath] = value
    XCTAssertEqual(self[keyPath: keyPath], value, file: file, line: line)
  }
  
  func assertFloatingPoint<T: FloatingPoint>(
    at keyPath: ReferenceWritableKeyPath<Preferences, T?>,
    with value: T,
    accuracy: T,
    file: StaticString = #file,
    line: UInt = #line) throws
  {
    XCTAssertNil(self[keyPath: keyPath], file: file, line: line)
    self[keyPath: keyPath] = value
    XCTAssertEqual(try self[keyPath: keyPath].unwrap(), value, accuracy: accuracy, file: file, line: line)
  }
}

// MARK: - Helpers

private final class Preferences {
  
  @Stored var string: String?
  @Stored var date: Date?
  @Stored var number: NSNumber?
  @Stored var int: Int?
  @Stored var uint: UInt?
  @Stored var double: Double?
  @Stored var float: Float?
  @Stored var bool: Bool?
  @Stored var url: URL?
  @Stored var data: Data?
  @Stored var array: [UInt]?
  @Stored var dictionary: [String: Int]?
  @Stored var userDetails: UserDetails?
  @Stored var temperatureUnit: TemperatureUnit?
  @Stored var weightUnit: WeightUnit
  
  init<S: KeyValueStore>(store: S) where S.Key == String {
    _string = Stored(key: "string", store: store)
    _date = Stored(key: "date", store: store)
    _number = Stored(key: "number", store: store)
    _int = Stored(key: "int", store: store)
    _uint = Stored(key: "uint", store: store)
    _double = Stored(key: "double", store: store)
    _float = Stored(key: "float", store: store)
    _bool = Stored(key: "bool", store: store)
    _url = Stored(key: "url", store: store)
    _data = Stored(key: "data", store: store)
    _array = Stored(key: "array", store: store)
    _dictionary = Stored(key: "dictionary", store: store)
    _userDetails = Stored(key: "userDetails", store: store)
    _temperatureUnit = Stored(key: "temperatureUnit", store: store)
    _weightUnit = Stored(key: "weightUnit", defaultValue: .grams, store: store)
  }
}

extension UserDetails: StorableCodable { }

extension TemperatureUnit: Storable {
  typealias RawValue = String
}

extension WeightUnit: Storable {
  typealias RawValue = String
}
