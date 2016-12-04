//
//  Bundle+Helpers.swift
//  Lightning
//
//  Created by Göksel Köksal on 04/12/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

extension Bundle {
    
    var zap_shortVersionString: String {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    var zap_buildNumberString: String {
        return object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    var zap_longVersionString: String {
        return "\(zap_shortVersionString) (\(zap_buildNumberString))"
    }
}
