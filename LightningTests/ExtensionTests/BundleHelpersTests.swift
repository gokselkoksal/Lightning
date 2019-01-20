//
//  BundleHelpersTests.swift
//  Lightning
//
//  Created by Göksel Köksal on 10/12/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import XCTest
@testable import Lightning

class BundleHelpersTests: XCTestCase {
  
  func testVersionStrings() {
    let bundle = Bundle(for: BundleHelpersTests.self)
    let shortVersion = bundle.zap_shortVersionString
    let buildVersion = bundle.zap_versionString
    XCTAssert(shortVersion == "1.0")
    XCTAssert(buildVersion == "1")
  }
}
