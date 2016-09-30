//
//  WSConfig.swift
//  koolicarproject
//
//  Created by Stephan Yannick on 30/09/2016.
//  Copyright © 2016 koolicar. All rights reserved.
//

import Foundation

typealias ResultAPI   = (Result<[String:AnyObject], WSResponse>) -> ()

/**
 * Enumerateur pour la config des WS
 */
enum WSConfig {
    
    case Cars(additional: String)
    // ...
}


extension WSConfig {
    
    var baseURL: String {
        return "http://yannickstephan.com/test/"
    }
    var path: String {
        switch self {
        case .Cars(let name):
            return "cars/\(name)"
        }
    }
    var absolutPath: String {
        return baseURL + path
    }
}

