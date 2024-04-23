//
//  NotificationViewModel.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/21/24.
//

import SwiftUI
import CoreLocation
import Foundation

class NotificationViewModel: ObservableObject {
    @Published var notificationSettings: [Notification]
    
    init(notificationSettings: [Notification]) {
        self.notificationSettings = notificationSettings
    }
    
    func updateNotificationSetting(_ setting: Notification) {
        if let index = notificationSettings.firstIndex(where: { $0.person.id == setting.person.id }) {
            notificationSettings[index] = setting
        }
    }
}



struct NotificationViewModel_Previews: PreviewProvider {
    static var previews: some View {
        let selectedPerson = PeopleDataService.shared.people.first!

        
        let person1 = Person(id: UUID(), name: "Alice", location: CLLocationCoordinate2D(latitude: 37.123, longitude: -122.456), profilePic: "alice_pic", notificationSettings: [])
        let person2 = Person(id: UUID(), name: "Bob", location: CLLocationCoordinate2D(latitude: 38.789, longitude: -123.789), profilePic: "bob_pic", notificationSettings: [])
        
        let personWrapper1 = PersonWrapper(person: person1)
        let personWrapper2 = PersonWrapper(person: person2)
        
        let viewModel = NotificationViewModel(notificationSettings: [])
        
        return NotificationSettingsView(person: selectedPerson, viewModel: viewModel)
            .environmentObject(personWrapper1)
            .environmentObject(personWrapper2)
    }
}
