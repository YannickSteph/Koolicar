//
//  KPDebug.swift
//  koolicarproject
//
//  Created by Stephan Yannick on 30/09/2016.
//  Copyright © 2016 koolicar. All rights reserved.
//

import Foundation

public enum KPDebug {
    
    static var debug = false
    
    static func print(val:Any) {
        if debug {
            Swift.print(val)
        }
    }
}
