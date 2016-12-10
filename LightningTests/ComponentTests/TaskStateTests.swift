//
//  TaskStateTests.swift
//  Lightning
//
//  Created by Göksel Köksal on 19/11/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import XCTest
@testable import Lightning

class TaskStateTests: XCTestCase {
    
    enum Exception: Error {
        case dummy
    }
    
    func testExample() {
        var state = TaskState<Int>()
        state.test(status: .idle, result: nil, latestValue: nil)
        state.setInProgress()
        state.test(status: .inProgress, result: nil, latestValue: nil)
        state.setFinished(with: Result.success(1))
        state.test(status: .finished, result: Result.success(1), latestValue: 1)
        state.setInProgress()
        state.test(status: .inProgress, result: Result.success(1), latestValue: 1)
        state.setCancelled()
        state.test(status: .cancelled, result: Result.success(1), latestValue: 1)
        state.setInProgress()
        state.test(status: .inProgress, result: Result.success(1), latestValue: 1)
        let failure = Result<Int>.failure(Exception.dummy)
        state.setFinished(with: failure)
        state.test(status: .finished, result: failure, latestValue: 1)
        state.reset(with: 1)
        state.test(status: .idle, result: Result.success(1), latestValue: 1)
        state.reset()
        state.test(status: .idle, result: nil, latestValue: nil)
    }
}

// MARK: Helpers

extension TaskState where Value: Equatable {
    
    func test(status: TaskStatus, result: Result<Value>?, latestValue: Value?) {
        XCTAssert(self.status == status)
        switch (self.result, result) {
        case (.some(let result1), .some(let result2)):
            result1.test(equalsTo: result2)
        case (.none, .none):
            XCTAssert(true)
        default:
            XCTFail("Results should be equal.")
        }
        XCTAssert(self.latestValue == latestValue)
    }
}

extension Result where Value: Equatable {
    
    func test(equalsTo result: Result<Value>) {
        switch (self, result) {
        case (.success(let value1), .success(let value2)):
            XCTAssert(value1 == value2)
        case (.failure, .failure):
            XCTAssert(true)
        default:
            XCTFail("Results should be equal.")
        }
    }
}
