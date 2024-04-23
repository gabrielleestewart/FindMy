//
//  Device.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/16/24.
//

import Foundation
import MapKit

struct Device {
    let id: UUID
    let name: String
    let location: CLLocationCoordinate2D
    let profilePic: String
}
