//
//  NotificationSettingsView.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/21/24.
//

import SwiftUI
import CoreLocation
import Foundation

struct NotificationSettingsView: View {
    let person: Person
    @ObservedObject var viewModel: NotificationViewModel
    @State private var cityStateMap: [UUID: String] = [:]
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAddActionSheet = false
    @State private var isAddLocationViewPresented = false
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(person.notificationSettings) { setting in
                    Section(header: Text("WHEN")) {
                        Picker(selection: $viewModel.notificationSettings[viewModel.notificationSettings.firstIndex(of: setting)!].when, label: Text("")) {
                            Text("\(self.person.name) Arrives").tag("\(self.person.name) Arrives")
                            Text("\(self.person.name) Leaves").tag("\(self.person.name) Leaves")
                            Text("\(self.person.name) Is Not At").tag("\(self.person.name) Is Not At")
                        }
                        .pickerStyle(.inline)
                        .labelsHidden()
                    }
                    
                    Section(header: Text("LOCATION")) {
                        Picker(selection: $viewModel.notificationSettings[viewModel.notificationSettings.firstIndex(of: setting)!].location, label: Text("")) {
                            HStack {
                                Text("\(self.person.name)'s Current Location").tag("\(self.person.name)'s Current Location")
                                Text("\(cityStateMap[person.id, default: "Locating..."])")
                            }
                            .onAppear {
                                fetchAreaName(for: person)
                            }
                            
                            HStack {
                                //a square preview of the person's current location should be here to the left of the text (hence the HStack)
                                Text("My Current Location").tag("My Current Location")
                            }
                            
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue)
                                Text("New Location").tag("New Location")
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        isAddLocationViewPresented = true
                                    }
                            }
                        }
                        .pickerStyle(InlinePickerStyle())
                        .labelsHidden()
                    }
                    
                    Section(header: Text("FREQUENCY")) {
                        Picker(selection: $viewModel.notificationSettings[viewModel.notificationSettings.firstIndex(of: setting)!].frequency, label: Text("")) {
                            Text("Only Once").tag("Only Once")
                            Text("Every Time").tag("Every Time")
                        }
                        .pickerStyle(InlinePickerStyle())
                        .labelsHidden()
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarItems(leading: HStack {
                cancelButton
                Text("Notify") //this should change depending on what was selected in the persondetailview. if "Notify Me" was selected, then it should be that. If "Notify /(person.name)" was selected, then it should be that.
                    .font(.title3)
                    .padding(.leading, 70)
                    .bold()
            } , trailing: addButton)
            .sheet(isPresented: $isAddLocationViewPresented) {
                AddLocationView(person: person)
            }
        }
    }
    var cancelButton: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var addButton: some View {
        Button(action: {
            showingAddActionSheet = true
        }) {
            Text("Add")
                .foregroundColor(.blue)
                .bold()
        }
        .actionSheet(isPresented: $showingAddActionSheet) {
            ActionSheet(
                title: Text("\(person.name) will be notified that you created this notification"),
                buttons: [
                    .destructive(Text("OK"), action: {
                        // This button should save the notification settings for this specific notification and add the notification to the notification section of peeopledetailview right above the add button. This notification should all be in an HStack that navigates back to the specific notification settings view for that saved notification. It should show if it is notifying me "Notify Me" or Notifying the person "Notify /(person.name)" in the title.3 font on the first line. The second line should show the details of the notification settings in the following form: if "Only Once" was selected in the “frequency” section of notification settings, then "Next time" should begin that second line. Otherwise, it should say “Every time” if the “Every Time” button is selected. Next, it should return the “when” section’s picker-selected option. Lastly, it should return the “location” section’s picker selected option.
                        presentationMode.wrappedValue.dismiss()
                    }),
                    .cancel(Text("Cancel"))
                ]
            )
        }
    }
    
    func showAddActionSheet() {
        showingAddActionSheet = true
    }
    
    func fetchAreaName(for person: Person) {
        let location = CLLocation(latitude: person.location.latitude, longitude: person.location.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No placemark found")
                cityStateMap[person.id] = "Address not available"
                return
            }
            
            if let areaName = placemark.locality {
                cityStateMap[person.id] = areaName
            } else if let adminArea = placemark.administrativeArea {
                cityStateMap[person.id] = adminArea
            } else {
                cityStateMap[person.id] = "Unknown Location"
            }
        }
    }
}


struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let selectedPerson = PeopleDataService.shared.people.first!
        
        var person1 = Person(id: UUID(), name: "Alice", location: CLLocationCoordinate2D(latitude: 37.123, longitude: -122.456), profilePic: "alice_pic", notificationSettings: [])
        
        let notification1 = Notification(id: UUID(), person: person1, notifyMe: true, notifyPerson: true, when: "Arrives", location: "Current Location", frequency: "Only Once")
        person1.notificationSettings.append(notification1)
        
        return NavigationView {
            NotificationSettingsView(person: person1, viewModel: NotificationViewModel(notificationSettings: person1.notificationSettings))
        }
    }
}
