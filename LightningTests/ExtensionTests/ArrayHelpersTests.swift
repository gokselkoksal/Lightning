//
//  ArrayHelpersTests.swift
//  Lightning
//
//  Created by Göksel Köksal on 5.03.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import XCTest
@testable import Lightning

class ArrayHelpersTests: XCTestCase {
    
    func testExample() throws {
        let array = [1, 2, 3]
        
        XCTAssertThrowsError(try array.element(at: -1), "Expected to throw.") { (error) in
            XCTAssertTrue(error is Array<Int>.IndexOutOfBoundsError)
        }
        
        XCTAssertEqual(try array.element(at: 0), 1)
        XCTAssertEqual(try array.element(at: 1), 2)
        XCTAssertEqual(try array.element(at: 2), 3)
        
        XCTAssertThrowsError(try array.element(at: 4), "Expected to throw.") { (error) in
            XCTAssertTrue(error is Array<Int>.IndexOutOfBoundsError)
        }
    }
}
