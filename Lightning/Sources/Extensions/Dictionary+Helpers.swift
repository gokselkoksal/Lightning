//
//  Dictionary+Helpers.swift
//  Lightning
//
//  Created by Göksel Köksal on 04/12/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

public extension Dictionary {
    
    public static func +(left: [Key: Value], right: [Key: Value]) -> [Key: Value] {
        var result = left
        for pair in right {
            result[pair.key] = pair.value
        }
        return result
    }
    
    public static func +=(left: inout [Key: Value], right: [Key: Value]) {
        for pair in right {
            left[pair.key] = pair.value
        }
    }
}
