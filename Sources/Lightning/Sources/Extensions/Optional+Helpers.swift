//
//  Optional+Helpers.swift
//  Lightning
//
//  Created by Göksel Köksal on 5.03.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation

public extension Optional {
  
  struct FoundNilWhileUnwrappingError: Error { }
  
  func unwrap() throws -> Wrapped {
    switch self {
    case .some(let wrapped):
      return wrapped
    case .none:
      throw FoundNilWhileUnwrappingError()
    }
  }
}
