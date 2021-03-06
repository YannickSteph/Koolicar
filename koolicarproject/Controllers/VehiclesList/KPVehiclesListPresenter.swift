//
//  KPVehiclesListPresenter.swift
//  koolicarproject
//
//  Created by Stephan Yannick on 30/09/2016.
//  Copyright (c) 2016 koolicar. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

public protocol KPVehiclesListPresenterInput {
    func presentVehicles()
    func presentVehiclesMap()
    func presentFailVehicles(error: KPVehiclesListError)
}

public protocol KPVehiclesListPresenterOutput: class {
    func displayVehicles()
    func displayVehiclesMap()
    func displayFailVehicles(description:String)
}

final class KPVehiclesListPresenter: KPGenericPresenter, KPVehiclesListPresenterInput {
    
    weak var output: KPVehiclesListPresenterOutput!
    
    // MARK: Presentation logic
    
    func presentVehicles() {
        output.displayVehicles()
    }
    
    public func presentVehiclesMap() {
        output.displayVehiclesMap()
    }
    
    public func presentFailVehicles(error: KPVehiclesListError) {
        output.displayFailVehicles(description: error.rawValue)
    }
}
