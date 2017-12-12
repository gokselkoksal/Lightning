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
    
    func testReadWrite() {
        let list = Protected(["item1"])
        XCTAssert(list.value == ["item1"])
        list.value = ["item1", "item2"]
        XCTAssert(list.value == ["item1", "item2"])
        list.read { items in
            XCTAssert(items == ["item1", "item2"])
        }
        list.write { items in
            var items = items
            items.append("item3")
            items.append("item4")
            items = items.map { string in
                let index = string.index(string.startIndex, offsetBy: 4)
                return String(string[index..<string.endIndex])
            }
            return items
        }
        XCTAssert(list.value == ["1", "2", "3", "4"])
    }
}
