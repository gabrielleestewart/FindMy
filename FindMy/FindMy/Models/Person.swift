//
//  Person.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/16/24.
//

import Foundation
import MapKit
import SwiftUI

struct Person: Identifiable, Equatable {
    let id: UUID
    let name: String
    let location: CLLocationCoordinate2D
    let profilePic: String
    var notificationSettings: [Notification] = []

    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }
}
class PersonWrapper: ObservableObject {
    @Published var person: Person
    
    init(person: Person) {
        self.person = person
    }
}
