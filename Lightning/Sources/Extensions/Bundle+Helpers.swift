//
//  Bundle+Helpers.swift
//  Lightning
//
//  Created by Göksel Köksal on 04/12/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

public extension Bundle {
  
  public var zap_shortVersionString: String {
    return object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
  }
  
  public var zap_versionString: String {
    return object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
  }
}
