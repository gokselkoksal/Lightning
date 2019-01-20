//
//  AtomicTests.swift
//  Lightning
//
//  Created by Goksel Koksal on 21/11/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import XCTest
@testable import Lightning

class AtomicTests: XCTestCase {
  
  func testReadWrite_array() {
    let atomicList = Atomic(["item1"])
    XCTAssert(atomicList.value == ["item1"])
    atomicList.value = ["item1", "item2"]
    XCTAssert(atomicList.value == ["item1", "item2"])
    atomicList.read { items in
      XCTAssert(items == ["item1", "item2"])
    }
    atomicList.write { list in
      list.append("item3")
      list.append("item4")
      list = list.map { string in
        let index = string.index(string.startIndex, offsetBy: 4)
        return String(string[index..<string.endIndex])
      }
    }
    XCTAssert(atomicList.value == ["1", "2", "3", "4"])
  }
  
  func testReadWrite_int() {
    let atomicNumber = Atomic(1)
    atomicNumber.write { (number) in
      number = 2
    }
    XCTAssertEqual(atomicNumber.value, 2)
  }
  
  func testReadWrite_string() {
    let atomicString = Atomic("Goksel")
    atomicString.write { (string) in
      string = "Koksal"
    }
    XCTAssertEqual(atomicString.value, "Koksal")
  }
  
  func testReadWrite_struct() {
    
    struct SomeStruct { // Local struct for testing purposes.
      
      var number: Int
      
      mutating func increment() {
        number += 1
      }
    }
    
    let atomicStruct = Atomic(SomeStruct(number: 1))
    atomicStruct.write { (someStruct) in
      someStruct.increment()
    }
    XCTAssertEqual(atomicStruct.value.number, 2)
  }
}
