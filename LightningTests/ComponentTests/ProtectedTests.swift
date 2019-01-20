//
//  ProtectedTests.swift
//  Lightning
//
//  Created by Goksel Koksal on 21/11/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import XCTest
@testable import Lightning

class ProtectedTests: XCTestCase {

    let iterationCount = 5000

    func testValueReadWrite() {
        let protectedItems = Protected<ContiguousArray<Int>>([])

        DispatchQueue.concurrentPerform(iterations: iterationCount) { i in
            // Dummy read
            XCTAssert(protectedItems.value.count >= 0)

            // Dummy write
            protectedItems.value = [i]
        }

        // If test reaches here without a crash, it is successful!
        XCTAssert(true)
    }

    func testSnycWrite() {
        let protectedItems = Protected<Set<Int>>([])

        DispatchQueue.concurrentPerform(iterations: iterationCount) { i in
            protectedItems.write(mode: .sync) { items in
                items.insert(i)
            }
        }

        Array(0..<iterationCount).forEach { i in
            XCTAssert(protectedItems.value.contains(i))
        }
    }

    func testAsyncWrite() {
        let protectedItems = Protected<Set<Int>>([])

        DispatchQueue.concurrentPerform(iterations: iterationCount) { i in
            protectedItems.write(mode: .async) { items in
                items.insert(i)
            }
        }

        Array(0..<iterationCount).forEach { i in
            XCTAssert(protectedItems.value.contains(i))
        }
    }

    func testConcurrentReadAsyncWrite() {
        let protectedItems = Protected<Set<Int>>([])

        DispatchQueue.concurrentPerform(iterations: iterationCount) { i in
            protectedItems.read { items in
                // Dummy read
                XCTAssert(items.count >= 0)
            }

            protectedItems.write(mode: .async) { items in
                items.insert(i)
            }
        }

        Array(0..<iterationCount).forEach { i in
            XCTAssert(protectedItems.value.contains(i))
        }
    }

    func testConcurrentReadSyncWrite() {
        let protectedItems = Protected<Set<Int>>([])

        DispatchQueue.concurrentPerform(iterations: iterationCount) { i in
            protectedItems.read { items in
                // Dummy read operation
                XCTAssert(items.count >= 0)
            }

            protectedItems.write(mode: .sync) { items in
                items.insert(i)
            }
        }

        Array(0..<iterationCount).forEach { i in
            XCTAssert(protectedItems.value.contains(i))
        }
    }
}
