//
//  StringKeyPathTests.swift
//  Lightning
//
//  Created by Göksel Köksal on 26.01.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import XCTest
import Lightning

class StringKeyPathTests: XCTestCase {
  
  private enum Keys {
    static let name = ValueKey<String>("user.name.first")
    static let surname = ValueKey<String>("user.name.last")
    static let age = ValueKey<Int>("user.age")
    static let isFavorite = ValueKey<Bool>("favorite")
  }
  
  private struct Data {
    let name = "Goksel"
    let surname = "Koksal"
    let age = 28
    let isFavorite = true
  }
  
  private let json: [String: Any] = [
    "user": [
      "name": [ "first": "Goksel", "last": "Koksal" ],
      "age": 28
    ],
    "favorite": true
  ]
  private let expected = Data()
  
  func test_keyPath_1key() {
    let key = StringKeyPath("user")
    XCTAssertEqual(key.value, "user")
    XCTAssertEqual(key.delimeter, ".")
    XCTAssertEqual(key.components.count, 1)
    XCTAssertEqual(key.firstKey, "user")
    XCTAssertEqual(key.lastKey, "user")
    XCTAssertEqual(key.isLeaf, true)
    XCTAssertEqual(key.dropFirstKey()?.value, nil)
  }
  
  func test_keyPath_2keys() {
    let key = StringKeyPath("user-name", delimeter: "-")
    XCTAssertEqual(key.value, "user-name")
    XCTAssertEqual(key.delimeter, "-")
    XCTAssertEqual(key.components.count, 2)
    XCTAssertEqual(key.firstKey, "user")
    XCTAssertEqual(key.lastKey, "name")
    XCTAssertEqual(key.isLeaf, false)
    XCTAssertEqual(key.dropFirstKey()?.value, "name")
  }
  
  func test_keyPath_3keys() {
    let key = StringKeyPath("user.name.first")
    XCTAssertEqual(key.value, "user.name.first")
    XCTAssertEqual(key.delimeter, ".")
    XCTAssertEqual(key.components.count, 3)
    XCTAssertEqual(key.firstKey, "user")
    XCTAssertEqual(key.lastKey, "first")
    XCTAssertEqual(key.isLeaf, false)
    XCTAssertEqual(key.dropFirstKey()?.value, "name.first")
  }
  
  func test_dictionary_keyPath() {
    XCTAssertEqual(json[keyPath: "user.name.first"] as? String, expected.name)
    XCTAssertEqual(json[keyPath: "user.name.last"] as? String, expected.surname)
    XCTAssertEqual(json[keyPath: "user.age"] as? Int, expected.age)
    XCTAssertEqual(json[keyPath: "favorite"] as? Bool, expected.isFavorite)
  }
  
  func test_dictionary_valueKey() {
    XCTAssertEqual(json[Keys.name], expected.name)
    XCTAssertEqual(json[Keys.surname], expected.surname)
    XCTAssertEqual(json[Keys.age], expected.age)
    XCTAssertEqual(json[Keys.isFavorite], expected.isFavorite)
  }
}
