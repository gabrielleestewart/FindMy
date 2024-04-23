//
//  ItemsDataService.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/18/24.
//

import Foundation
import MapKit
import SwiftUI


class ItemsDataService: ObservableObject {
    static let shared = ItemsDataService()
    
    var items: [Item] = [
        Item(id: UUID(), name: "Gabrielle's Keys", location: CLLocationCoordinate2D(latitude: 35.91054, longitude: -79.04712), profilePic: "key.pic")
    ]
    
    func cityAndState(for item: Item, completion: @escaping (String) -> Void) {
        let location = CLLocation(latitude: item.location.latitude, longitude: item.location.longitude)
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
    func removeItem(_ item: Item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items.remove(at: index)
        }
    }
}
