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

  let iterationCount = 5000
  
  func testStructReadWrite() {
    
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

  func testValueReadWrite() {
    let atomicArray = Atomic<ContiguousArray<Int>>([])

    DispatchQueue.concurrentPerform(iterations: iterationCount) { i in
      // Dummy read
      XCTAssert(atomicArray.value.count >= 0)

      // Dummy write
      atomicArray.value = [i]
    }

    // If test reaches here without a crash, it is successful!
    XCTAssert(true)
  }

  func testSnycWrite() {
    let atomicSet = Atomic<Set<Int>>([])

    DispatchQueue.concurrentPerform(iterations: iterationCount) { i in
      atomicSet.syncWrite { items in
        items.insert(i)
      }
    }

    Array(0..<iterationCount).forEach { i in
      XCTAssert(atomicSet.value.contains(i))
    }
  }

  func testAsyncWrite() {
    let atomics = Atomic<Set<Int>>([])

    DispatchQueue.concurrentPerform(iterations: iterationCount) { i in
      atomics.asyncWrite { items in
        items.insert(i)
      }
    }

    Array(0..<iterationCount).forEach { i in
      XCTAssert(atomics.value.contains(i))
    }
  }

  func testConcurrentReadAsyncWrite() {
    let atomicSet = Atomic<Set<Int>>([])

    DispatchQueue.concurrentPerform(iterations: iterationCount) { i in
      atomicSet.read { items in
        // Dummy read
        XCTAssert(items.count >= 0)
      }

      atomicSet.asyncWrite { items in
        items.insert(i)
      }
    }

    Array(0..<iterationCount).forEach { i in
      XCTAssert(atomicSet.value.contains(i))
    }
  }

  func testConcurrentReadSyncWrite() {
    let atomicSet = Atomic<Set<Int>>([])

    DispatchQueue.concurrentPerform(iterations: iterationCount) { i in
      atomicSet.read { items in
        // Dummy read operation
        XCTAssert(items.count >= 0)
      }

      atomicSet.syncWrite { items in
        items.insert(i)
        return
      }
    }

    Array(0..<iterationCount).forEach { i in
      XCTAssert(atomicSet.value.contains(i))
    }
  }
}
