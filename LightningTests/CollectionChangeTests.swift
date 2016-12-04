//
//  CollectionChangeTests.swift
//  Lightning
//
//  Created by Göksel Köksal on 19/11/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import XCTest
@testable import Lightning

class CollectionChangeTests: XCTestCase {
    
    let reload1 = CollectionChange.reload
    let reload2 = CollectionChange.reload
    
    let insertion1 = CollectionChange.insertion(1)
    let insertion2 = CollectionChange.insertion(1)
    let insertion3 = CollectionChange.insertion(2)
    
    let deletion1 = CollectionChange.deletion(1)
    let deletion2 = CollectionChange.deletion(1)
    let deletion3 = CollectionChange.deletion(2)
    
    let update1 = CollectionChange.update(1)
    let update2 = CollectionChange.update(1)
    let update3 = CollectionChange.update(2)
    
    let move1 = CollectionChange.move(from: 0, to: 1)
    let move2 = CollectionChange.move(from: 0, to: 1)
    let move3 = CollectionChange.move(from: 0, to: 2)
    let move4 = CollectionChange.move(from: 1, to: 1)
    let move5 = CollectionChange.move(from: 1, to: 2)
    
    func testIndexSetConvertible() {
        let indexes = 1.asIndexSet()
        XCTAssert(indexes.count == 1)
        XCTAssert(indexes.contains(1))
    }
    
    func testIndexPathConvertible() {
        let indexPath = 2.asIndexPath()
        XCTAssert(indexPath.count == 1)
        XCTAssert(indexPath.first == indexPath.last)
        if let first = indexPath.first {
            XCTAssert(first == 2)
        } else {
            XCTFail("Index path is not constructed correctly.")
        }
    }
    
    func testIndexPathSetConvertible() {
        let indexPath1 = IndexPath(index: 1)
        let indexPath2 = IndexPath(index: 2)
        let indexPath3 = IndexPath(index: 3)
        
        let convertible1 = 1.asIndexPath()
        let convertible2 = 2.asIndexPath()
        let convertible3 = 3.asIndexPath()
        
        XCTAssert(indexPath1 == convertible1)
        XCTAssert(indexPath2 == convertible2)
        XCTAssert(indexPath3 == convertible3)
        
        var indexSet = IndexSet()
        indexSet.insert(1)
        indexSet.insert(2)
        indexSet.insert(3)
        
        let indexPathSet = indexSet.asIndexPathSet()
        XCTAssert(indexPathSet.count == 3)
        XCTAssert(indexPathSet.contains(indexPath1))
        XCTAssert(indexPathSet.contains(indexPath2))
        XCTAssert(indexPathSet.contains(indexPath3))
    }
    
    func testReload() {
        XCTAssert(reload1 == reload2)
        XCTAssert(reload1 != insertion1)
        XCTAssert(reload1 != deletion1)
        XCTAssert(reload1 != update1)
        XCTAssert(reload1 != move1)
    }
    
    func testInsertion() {
        XCTAssert(insertion1 == insertion2)
        XCTAssert(insertion1 != insertion3)
        XCTAssert(insertion1 != reload1)
        XCTAssert(insertion1 != deletion1)
        XCTAssert(insertion1 != update1)
        XCTAssert(insertion1 != move1)
    }
    
    func testDeletion() {
        XCTAssert(deletion1 == deletion2)
        XCTAssert(deletion1 != deletion3)
        XCTAssert(deletion1 != reload1)
        XCTAssert(deletion1 != insertion1)
        XCTAssert(deletion1 != update1)
        XCTAssert(deletion1 != move1)
    }
    
    func testUpdate() {
        XCTAssert(update1 == update2)
        XCTAssert(update1 != update3)
        XCTAssert(update1 != reload1)
        XCTAssert(update1 != insertion1)
        XCTAssert(update1 != deletion1)
        XCTAssert(update1 != move1)
    }
    
    func testMove() {
        XCTAssert(move1 == move2)
        XCTAssert(move1 != move3)
        XCTAssert(move1 != reload1)
        XCTAssert(move1 != insertion1)
        XCTAssert(move1 != deletion1)
        XCTAssert(move1 != update1)
    }
}
