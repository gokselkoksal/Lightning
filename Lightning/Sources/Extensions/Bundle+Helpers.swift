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

// MARK: - Deprecated

public extension Bundle {
    
    @available(*, deprecated, message: "Use version string instead. It's not guaranteed to be a build number.")
    public var zap_buildNumberString: String {
        return object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    @available(*, deprecated, message: "Will be removed in 1.0. Cannot possibly produce a correct result for every project.")
    public var zap_longVersionString: String {
        return "\(zap_shortVersionString) (\(zap_buildNumberString))"
    }
}
