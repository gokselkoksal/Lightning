//
//  CollectionChange.swift
//  Lightning
//
//  Created by Göksel Köksal on 19/11/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

/// Represents a change in a collection like table view, array, etc.
///
/// - reload: Data source got reloaded.
/// - update: Data source updated given index path set.
/// - insertion: Data source inserted new items at given index path set.
/// - deletion: Data source deleted items from given index path set.
/// - move: Data source moved items from index path to another index path.
///
/// `IndexPathSetConvertible` lets you construct the `CollectionChange` however you want.
///
/// Some constructor examples:
/// ```
/// // Using `Int`, `UInt` or `IndexPath`:
/// CollectionChange.insertion(Int(2))
/// CollectionChange.insertion(UInt(1))
/// CollectionChange.insertion(IndexPath(row: 1, section: 0))
/// CollectionChange.move(from: 0, to: 1)
/// CollectionChange.move(from: IndexPath(row: 0, section: 0), to: IndexPath(row: 1, section: 0))
/// // Using `IndexSet`:
/// CollectionChange.insertion(IndexSet(arrayLiteral: 1, 2, 3))
/// // Using `Array`:
/// CollectionChange.insertion([1, 2, 3])
/// CollectionChange.insertion([IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)])
/// // Using `Set`:
/// CollectionChange.insertion(Set(arrayLiteral: 1, 2, 3))
/// CollectionChange.insertion(Set(arrayLiteral: IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)))
/// ```
///
/// Example 1:
/// ```
/// let change = CollectionChange.insertion(1)
///
/// switch change {
/// case .insertion(let indexes):
///   for indexPath in indexes.asIndexPathSet() {
///     print("\(indexPath)")       // Prints "[1]"
///     print("\(indexPath.first)") // Prints "Optional(1)"
///   }
/// default:
///   break
/// }
/// ```
///
/// Example 2:
/// ```
/// let indexPath = IndexPath(row: 1, section: 0)
/// let change = CollectionChange.insertion(indexPath)
///
/// switch change {
/// case .insertion(let indexes):
///   for indexPath in indexes.asIndexPathSet() {
///     print("\(indexPath)") // Prints "[0, 1]"
///   }
/// default:
///   break
/// }
/// ```
public enum CollectionChange {
  case reload
  case update(IndexPathSetConvertible)
  case insertion(IndexPathSetConvertible)
  case deletion(IndexPathSetConvertible)
  case move(from: IndexPathConvertible, to: IndexPathConvertible)
}

// MARK: - IndexPathConvertible

/// Anything that is convertible to an index path.
public protocol IndexPathConvertible {
  func asIndexPath() -> IndexPath
}

extension IndexPath: IndexPathConvertible {
  public func asIndexPath() -> IndexPath {
    return self
  }
}

extension UInt: IndexPathConvertible {
  public func asIndexPath() -> IndexPath {
    return IndexPath(index: Int(self))
  }
}

extension Int: IndexPathConvertible {
  public func asIndexPath() -> IndexPath {
    return IndexPath(index: self)
  }
}

// MARK: - IndexPathSetConvertible

/// Anything that is convertible to an index path set.
public protocol IndexPathSetConvertible {
  func asIndexPathSet() -> Set<IndexPath>
}

extension Array: IndexPathSetConvertible where Element: IndexPathConvertible {
  public func asIndexPathSet() -> Set<IndexPath> {
    return Set<IndexPath>(self.map({ $0.asIndexPath() }))
  }
}

extension Set: IndexPathSetConvertible where Element: IndexPathConvertible {
  public func asIndexPathSet() -> Set<IndexPath> {
    return Set<IndexPath>(self.map({ $0.asIndexPath() }))
  }
}

extension IndexSet: IndexPathSetConvertible {
  public func asIndexPathSet() -> Set<IndexPath> {
    return Set<IndexPath>(self.map({ $0.asIndexPath() }))
  }
}

extension IndexPath: IndexPathSetConvertible {
  public func asIndexPathSet() -> Set<IndexPath> {
    return Set<IndexPath>(arrayLiteral: self.asIndexPath())
  }
}

extension Int: IndexPathSetConvertible {
  public func asIndexPathSet() -> Set<IndexPath> {
    return Set<IndexPath>(arrayLiteral: self.asIndexPath())
  }
}

extension UInt: IndexPathSetConvertible {
  public func asIndexPathSet() -> Set<IndexPath> {
    return Set<IndexPath>(arrayLiteral: self.asIndexPath())
  }
}

// MARK: Equatable

extension CollectionChange: Equatable {
  
  public static func ==(lhs: CollectionChange, rhs: CollectionChange) -> Bool {
    switch (lhs, rhs) {
    case (.reload, .reload):
      return true
    case (.insertion(let indexes1), .insertion(let indexes2)):
      return indexes1.asIndexPathSet() == indexes2.asIndexPathSet()
    case (.deletion(let indexes1), .deletion(let indexes2)):
      return indexes1.asIndexPathSet() == indexes2.asIndexPathSet()
    case (.update(let indexes1), .update(let indexes2)):
      return indexes1.asIndexPathSet() == indexes2.asIndexPathSet()
    case (.move(let from1, let to1), .move(let from2, let to2)):
      return from1.asIndexPath() == from2.asIndexPath() && to1.asIndexPath() == to2.asIndexPath()
    default:
      return false
    }
  }
}
