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
  
  private let reload1 = CollectionChange.reload
  private let reload2 = CollectionChange.reload
  
  private let insertion1 = CollectionChange.insertion(1)
  private let insertion1copy = CollectionChange.insertion(1)
  private let insertion2 = CollectionChange.insertion(2)
  
  private let deletion1 = CollectionChange.deletion(1)
  private let deletion1copy = CollectionChange.deletion(1)
  private let deletion2 = CollectionChange.deletion(2)
  
  private let update1 = CollectionChange.update(1)
  private let update1copy = CollectionChange.update(1)
  private let update2 = CollectionChange.update(2)
  
  private let move01 = CollectionChange.move(from: 0, to: 1)
  private let move01copy = CollectionChange.move(from: 0, to: 1)
  private let move02 = CollectionChange.move(from: 0, to: 2)
  private let move11 = CollectionChange.move(from: 1, to: 1)
  private let move12 = CollectionChange.move(from: 1, to: 2)
  
  private let indexPath00 = IndexPath(row: 0, section: 0)
  private let indexPath01 = IndexPath(row: 1, section: 0)
  
  func testIndexPathConvertible() {
    let indexPath = 2.asIndexPath()
    XCTAssertEqual(indexPath.count, 1)
    XCTAssertEqual(indexPath.first, 2)
    XCTAssertEqual(indexPath.first, indexPath.last)
  }
  
  func testIndexPathSetConvertible() {
    let indexPath1 = IndexPath(index: 1)
    let indexPath2 = IndexPath(index: 2)
    
    let convertible1 = 1.asIndexPath()
    let convertible2 = 2.asIndexPath()
    
    XCTAssertEqual(indexPath1, convertible1)
    XCTAssertEqual(indexPath2, convertible2)
    
    var indexSet = IndexSet()
    indexSet.insert(1)
    indexSet.insert(2)
    
    let indexPathSet = indexSet.asIndexPathSet()
    XCTAssertEqual(indexPathSet.count, 2)
    XCTAssertTrue(indexPathSet.contains(indexPath1))
    XCTAssertTrue(indexPathSet.contains(indexPath2))
  }
  
  func testEquatable_reload() {
    XCTAssert(reload1 == reload2)
    XCTAssert(reload1 != insertion1)
    XCTAssert(reload1 != deletion1)
    XCTAssert(reload1 != update1)
    XCTAssert(reload1 != move01)
  }
  
  func testEquatable_insertion() {
    XCTAssert(insertion1 == insertion1copy)
    XCTAssert(insertion1 != insertion2)
    XCTAssert(insertion1 != reload1)
    XCTAssert(insertion1 != deletion1)
    XCTAssert(insertion1 != update1)
    XCTAssert(insertion1 != move01)
  }
  
  func testEquatable_deletion() {
    XCTAssert(deletion1 == deletion1copy)
    XCTAssert(deletion1 != deletion2)
    XCTAssert(deletion1 != reload1)
    XCTAssert(deletion1 != insertion1)
    XCTAssert(deletion1 != update1)
    XCTAssert(deletion1 != move01)
  }
  
  func testEquatable_update() {
    XCTAssert(update1 == update1copy)
    XCTAssert(update1 != update2)
    XCTAssert(update1 != reload1)
    XCTAssert(update1 != insertion1)
    XCTAssert(update1 != deletion1)
    XCTAssert(update1 != move01)
  }
  
  func testEquatable_move() {
    XCTAssert(move01 == move01copy)
    XCTAssert(move01 != move02)
    XCTAssert(move01 != reload1)
    XCTAssert(move01 != insertion1)
    XCTAssert(move01 != deletion1)
    XCTAssert(move01 != update1)
  }
  
  func testIntConversion() {
    let insertionChange = CollectionChange.insertion(Int(2))
    let moveChange = CollectionChange.move(from: Int(0), to: Int(1))
    
    switch insertionChange {
    case .insertion(let indexes):
      let set = indexes.asIndexPathSet()
      XCTAssertEqual(set.count, 1)
      XCTAssertTrue(set.contains(IndexPath(index: 2)))
    default:
      XCTFail("Should be insertion.")
    }
    
    switch moveChange {
    case .move(from: let index1, to: let index2):
      XCTAssertEqual(index1.asIndexPath(), IndexPath(index: 0))
      XCTAssertEqual(index2.asIndexPath(), IndexPath(index: 1))
    default:
      XCTFail("Should be move.")
    }
  }
  
  func testUIntConversion() {
    let change = CollectionChange.insertion(UInt(2))
    let moveChange = CollectionChange.move(from: UInt(0), to: UInt(1))
    
    switch change {
    case .insertion(let indexes):
      let set = indexes.asIndexPathSet()
      XCTAssertEqual(set.count, 1)
      XCTAssertTrue(set.contains(IndexPath(index: 2)))
    default:
      XCTFail("Should be insertion.")
    }
    
    switch moveChange {
    case .move(from: let index1, to: let index2):
      XCTAssertEqual(index1.asIndexPath(), IndexPath(index: 0))
      XCTAssertEqual(index2.asIndexPath(), IndexPath(index: 1))
    default:
      XCTFail("Should be move.")
    }
  }
  
  func testIndexPathConversion() {
    let insertionChange = CollectionChange.insertion(indexPath01)
    let moveChange = CollectionChange.move(from: indexPath00, to: indexPath01)
    
    switch insertionChange {
    case .insertion(let indexes):
      let set = indexes.asIndexPathSet()
      XCTAssertEqual(set.count, 1)
      XCTAssertTrue(set.contains(indexPath01))
    default:
      XCTFail("Should be insertion.")
    }
    
    switch moveChange {
    case .move(from: let index1, to: let index2):
      XCTAssertEqual(index1.asIndexPath(), indexPath00)
      XCTAssertEqual(index2.asIndexPath(), indexPath01)
    default:
      XCTFail("Should be move.")
    }
  }
  
  func testIndexSetConversion() {
    let change = CollectionChange.insertion(IndexSet(arrayLiteral: 1, 2))
    
    switch change {
    case .insertion(let indexes):
      let set = indexes.asIndexPathSet()
      XCTAssertEqual(set.count, 2)
      XCTAssertTrue(set.contains(IndexPath(index: 1)))
      XCTAssertTrue(set.contains(IndexPath(index: 2)))
    default:
      XCTFail("Should be insertion.")
    }
  }
  
  func testArrayConversion() {
    let change1 = CollectionChange.insertion([1, 2])
    let change2 = CollectionChange.insertion([indexPath00, indexPath01])
    
    switch change1 {
    case .insertion(let indexes):
      let set = indexes.asIndexPathSet()
      XCTAssertEqual(set.count, 2)
      XCTAssertTrue(set.contains(IndexPath(index: 1)))
      XCTAssertTrue(set.contains(IndexPath(index: 2)))
    default:
      XCTFail("Should be insertion.")
    }
    
    switch change2 {
    case .insertion(let indexes):
      let set = indexes.asIndexPathSet()
      XCTAssertEqual(set.count, 2)
      XCTAssertTrue(set.contains(indexPath00))
      XCTAssertTrue(set.contains(indexPath01))
    default:
      XCTFail("Should be insertion.")
    }
  }
  
  func testSetConversion() {
    let change1 = CollectionChange.insertion(Set(arrayLiteral: 1, 2))
    let change2 = CollectionChange.insertion(Set(arrayLiteral: indexPath00, indexPath01))
    
    switch change1 {
    case .insertion(let indexes):
      let set = indexes.asIndexPathSet()
      XCTAssertEqual(set.count, 2)
      XCTAssertTrue(set.contains(IndexPath(index: 1)))
      XCTAssertTrue(set.contains(IndexPath(index: 2)))
    default:
      XCTFail("Should be insertion.")
    }
    
    switch change2 {
    case .insertion(let indexes):
      let set = indexes.asIndexPathSet()
      XCTAssertEqual(set.count, 2)
      XCTAssertTrue(set.contains(indexPath00))
      XCTAssertTrue(set.contains(indexPath01))
    default:
      XCTFail("Should be insertion.")
    }
  }
}
