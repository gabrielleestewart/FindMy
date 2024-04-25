//
//  PeopleDataService.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/16/24.
//

import Foundation
import MapKit
import SwiftUI


class PeopleDataService: ObservableObject {
    static let shared = PeopleDataService()
    
    var people: [Person] = [
        Person(id: UUID(), name: "Melanie Andrade-Muñoz", location: CLLocationCoordinate2D(latitude: 35.91074, longitude: -79.05239), profilePic: "mel.pic", notificationSettings: []),
        Person(id: UUID(), name: "Savv Lin", location: CLLocationCoordinate2D(latitude: 35.91074, longitude: -79.05239), profilePic: "savv.pic", notificationSettings: []),
        Person(id: UUID(), name: "Rodrigo Roque-Hernandez", location: CLLocationCoordinate2D(latitude: 35.91259, longitude: -79.04646), profilePic: "rodrigo.pic", notificationSettings: []),
        Person(id: UUID(), name: "Vy Bui", location: CLLocationCoordinate2D(latitude: 35.91259, longitude: -79.04646), profilePic: "vy.pic", notificationSettings: []),
        Person(id: UUID(), name: "Kennedy Cameron", location: CLLocationCoordinate2D(latitude: 35.91248, longitude: -79.04491), profilePic: "ken.pic", notificationSettings: [])
    ]
    
    func cityAndState(for person: Person, completion: @escaping (String) -> Void) {
        let location = CLLocation(latitude: person.location.latitude, longitude: person.location.longitude)
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
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.91054, longitude: -79.04712), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))

    func updateRegion() {
            guard let firstPerson = people.first else { return }
            var minLat = firstPerson.location.latitude
            var maxLat = firstPerson.location.latitude
            var minLon = firstPerson.location.longitude
            var maxLon = firstPerson.location.longitude
            
            for person in people {
                minLat = min(minLat, person.location.latitude)
                maxLat = max(maxLat, person.location.latitude)
                minLon = min(minLon, person.location.longitude)
                maxLon = max(maxLon, person.location.longitude)
            }
            
            let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
            let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.1, longitudeDelta: (maxLon - minLon) * 1.1)
            region = MKCoordinateRegion(center: center, span: span)
        }
    
    func removePerson(_ person: Person) {
        if let index = people.firstIndex(where: { $0.id == person.id }) {
            people.remove(at: index)
            objectWillChange.send()
        }
    }
}
