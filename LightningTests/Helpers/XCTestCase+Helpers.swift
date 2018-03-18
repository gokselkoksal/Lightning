//
//  XCTestCase+Helpers.swift
//  Lightning
//
//  Created by Göksel Köksal on 5.03.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    func waitExecution(for taskName: String, timeout: TimeInterval = 0.5, block: (_ finish: @escaping () -> Void) -> Void) {
        let exp = expectation(description: taskName)
        block {
            exp.fulfill()
        }
        wait(for: [exp], timeout: timeout)
    }
}
