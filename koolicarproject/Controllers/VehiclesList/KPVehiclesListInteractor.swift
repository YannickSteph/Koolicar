//
//  KPVehiclesListInteractor.swift
//  koolicarproject
//
//  Created by Stephan Yannick on 30/09/2016.
//  Copyright (c) 2016 koolicar. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import CoreLocation

public protocol KPVehiclesListInteractorInput {
    var vehicles: [VehicleModel] { get }
    func fetchVehicleData()
    func fetchFilteredVehicleData(coordinates:[CLLocationCoordinate2D])
}

public protocol KPVehiclesListInteractorOutput {
    func presentVehicles()
    func presentVehiclesMap()
    func presentFailVehicles(error: KPVehiclesListError)
}

final class KPVehiclesListInteractor: KPGenericInteractor, KPVehiclesListInteractorInput {
    
    var output: KPVehiclesListInteractorOutput!
    var worker: KPVehiclesListWorker!
    
    private(set) var vehicles: [VehicleModel] = []
    fileprivate var vehiclesStorage: [VehicleModel] = []
    
    // MARK: Business logic
    
    public func fetchVehicleData() {
        guard KPHelpers.isConnectedToNetwork() else {
            output.presentFailVehicles(error: .noNetwork)
            return
        }
        KPVehiclesListWorker.requestVehicles() {
            result in
            switch (result) {
            case let .success(result):
                self.vehiclesStorage = result
                self.vehicles = self.vehiclesStorage
                self.output.presentVehiclesMap()
                break
                
                
            case .failure(_):
                // TODO: Intépreter les codes error et Http avec un enumérateur, ici mit en dur
                self.output.presentFailVehicles(error: .noData)
                break
            }
        }
    }
    
    public func fetchFilteredVehicleData(coordinates: [CLLocationCoordinate2D]) {
        DispatchQueue.global(qos: .userInitiated).async {  [weak self] () -> Void in
            guard let vehicles = self?.filterVehiclesByCoordinates(coordinates: coordinates) else {
                return
            }
            DispatchQueue.main.async {
                self?.vehicles = vehicles
                self?.output.presentVehicles()
            }
        }
    }
    
    fileprivate func filterVehiclesByCoordinates(coordinates: [CLLocationCoordinate2D]) -> [VehicleModel]? {
        var vehiclesFilter = [VehicleModel]()
        var reloadNeed = false
        for coordinate in coordinates {
            let vehiclesFilterCoordinate = self.vehiclesStorage.filter({
                $0.location.latitude == coordinate.latitude &&
                $0.location.longitude == coordinate.longitude
            })
            for v in vehiclesFilterCoordinate {
                if !vehiclesFilter.contains(v) {
                    vehiclesFilter.append(v)
                }
            }
        }
        for v in vehiclesFilter {
            if !self.vehicles.contains(v) {
                reloadNeed = true
                break
            }
        }
        // Pour ne recharger que si besoin
        return (reloadNeed || !(vehiclesFilter.count == self.vehicles.count)) ? vehiclesFilter : nil
    }
}
