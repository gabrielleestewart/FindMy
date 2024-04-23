//
//  DevicesDataService.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/18/24.
//

import Foundation
import MapKit
import SwiftUI


class DevicesDataService: ObservableObject {
    static let shared = DevicesDataService()
    
    var devices: [Device] = [
        Device(id: UUID(), name: "Gabrielle's iPhone", location: CLLocationCoordinate2D(latitude: 35.91054, longitude: -79.04712), profilePic: "iphone.pic"),
        Device(id: UUID(), name: "Gabrielle's Apple Watch", location: CLLocationCoordinate2D(latitude: 35.91054, longitude: -79.04712), profilePic: "watch.pic"),
        Device(id: UUID(), name: "Gabrielle's iPad", location: CLLocationCoordinate2D(latitude: 35.91248, longitude: -79.04491), profilePic: "ipad.pic")
    ]
    
    func cityAndState(for device: Device, completion: @escaping (String) -> Void) {
        let location = CLLocation(latitude: device.location.latitude, longitude: device.location.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion("Unknown")
                return
            }
            if let city = placemark.locality, let state = placemark.administrativeArea {
                completion("\(city), \(state)")
            } else {
                completion("Unknown")
            }
        }
    }
    func eraseDevice(_ device: Device) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices.remove(at: index)
        }
    }
}
