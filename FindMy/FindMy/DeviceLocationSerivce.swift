//
//  DeviceLocationSerivce.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/16/24.
//

import Combine
import CoreLocation
import SwiftUI

class DeviceLocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    var coordinatesPublisher = PassthroughSubject<CLLocationCoordinate2D, Error>()
    var deniedLocationAccessPublisher = PassthroughSubject<Void, Never>()
    
    static let shared = DeviceLocationService()
    override init() {
        super.init()
    }

    lazy var locationManager: CLLocationManager? = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.delegate = self
        return manager
    }()
    
    /*
     Accuracy Options:
     kCLLocationAccuracyBestForNavigation, kCLLocationAccuracyBest, kCLLocationAccuracyNearestTenMeters, kCLLocationAccuracyHundredMeters, kCLLocationAccuracyKilometer, kCLLocationAccuracyThreeKilometers, and kCLLocationAccuracyReduced
     */
    
    func requestLocationUpdates() {
        switch locationManager?.authorizationStatus {
            
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager?.startUpdatingLocation()
        
        case .denied:
            print("You have denied \"Find My\" location permission. Go into settings to allow permission.")
        default:
            deniedLocationAccessPublisher.send()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
            
        default:
            manager.stopUpdatingLocation()
            deniedLocationAccessPublisher.send()
        }
    }
    
    // location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        coordinatesPublisher.send(location.coordinate)
    }
    
    // for location update errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        coordinatesPublisher.send(completion: .failure(error))
    }
}
