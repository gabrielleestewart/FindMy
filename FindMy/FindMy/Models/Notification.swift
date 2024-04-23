//
//  Notification.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/21/24.
//

import Foundation

struct Notification: Identifiable, Equatable {
    let id: UUID
    let person: Person
    var notifyMe: Bool
    var notifyPerson: Bool
    var when: String
    var location: String
    var frequency: String
    
    var notifyMeAlertIsShowing: Bool = false
    var notifyPersonAlertIsShowing: Bool = false
    
    static func == (lhs: Notification, rhs: Notification) -> Bool {
        return lhs.id == rhs.id
    }
}
