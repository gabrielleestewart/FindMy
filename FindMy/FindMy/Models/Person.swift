//
//  Person.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/16/24.
//

import Foundation
import MapKit
import SwiftUI

struct Person: Identifiable {
    let id: UUID
    let name: String
    let location: CLLocationCoordinate2D
    let profilePic: String
    var notificationSettings: [Notification]
}

class PersonWrapper: ObservableObject {
    @Published var person: Person
    
    init(person: Person) {
        self.person = person
    }
}
