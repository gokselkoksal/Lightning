//
//  BoundsTests.swift
//  Lightning
//
//  Created by Göksel Köksal on 28/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import XCTest
@testable import Lightning

class BoundsTests: XCTestCase {
    
    func testInclusiveInclusive() {
        let bounds = Bounds(.inclusive(2), .inclusive(5))
        XCTAssertFalse(bounds.contains(0))
        XCTAssertFalse(bounds.contains(1))
        XCTAssertTrue(bounds.contains(2))
        XCTAssertTrue(bounds.contains(3))
        XCTAssertTrue(bounds.contains(4))
        XCTAssertTrue(bounds.contains(5))
        XCTAssertFalse(bounds.contains(6))
    }
    
    func testInclusiveExclusive() {
        let bounds = Bounds(.inclusive(2), .exclusive(5))
        XCTAssertFalse(bounds.contains(0))
        XCTAssertFalse(bounds.contains(1))
        XCTAssertTrue(bounds.contains(2))
        XCTAssertTrue(bounds.contains(3))
        XCTAssertTrue(bounds.contains(4))
        XCTAssertFalse(bounds.contains(5))
        XCTAssertFalse(bounds.contains(6))
    }
    
    func testExclusiveInclusive() {
        let bounds = Bounds(.exclusive(2), .inclusive(5))
        XCTAssertFalse(bounds.contains(0))
        XCTAssertFalse(bounds.contains(1))
        XCTAssertFalse(bounds.contains(2))
        XCTAssertTrue(bounds.contains(3))
        XCTAssertTrue(bounds.contains(4))
        XCTAssertTrue(bounds.contains(5))
        XCTAssertFalse(bounds.contains(6))
    }
    
    func testExclusiveExclusive() {
        let bounds = Bounds(.exclusive(2), .exclusive(5))
        XCTAssertFalse(bounds.contains(0))
        XCTAssertFalse(bounds.contains(1))
        XCTAssertFalse(bounds.contains(2))
        XCTAssertTrue(bounds.contains(3))
        XCTAssertTrue(bounds.contains(4))
        XCTAssertFalse(bounds.contains(5))
        XCTAssertFalse(bounds.contains(6))
    }
}
