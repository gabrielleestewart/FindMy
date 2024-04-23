//
//  AddLocationView.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/21/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct AddLocationView: View {
    @State private var searchText: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.9049, longitude: -79.0469), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    @State private var notificationRadius: CLLocationDistance = 1000
    //@State private var coordinates = Coordinates(lat: 35.9049, lon: -79.0469)
    @State private var circleSize: CircleSize = .medium
    @ObservedObject var deviceViewModel = DeviceListViewModel(devices: [])
    @ObservedObject var personViewModel = PersonListViewModel(people: [])
    @ObservedObject var itemViewModel = ItemListViewModel(items: [])

    let person: Person
    
    init(person: Person) {
        self.person = person
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                
//                MapView(region: $mapRegion, radius: $notificationRadius, coordinates: coordinates, tab: .constant(.people), deviceViewModel: deviceViewModel, personViewModel: personViewModel, itemViewModel: itemViewModel)
                    /*.onAppear {
                        // Update map region to center around person's coordinates
                        mapRegion = MKCoordinateRegion(center: person.location, latitudinalMeters: notificationRadius * 2, longitudinalMeters: notificationRadius * 2)
                    }*/
                
                Picker("Circle Size", selection: $circleSize) {
                    Text("Small").tag(CircleSize.small)
                    Text("Medium").tag(CircleSize.medium)
                    Text("Large").tag(CircleSize.large)
                }
                .pickerStyle(SegmentedPickerStyle())
                
            }
            .navigationBarItems(leading: cancelButton, trailing: doneButton)
        }
    }
    
    private func increaseRadius() {
        notificationRadius += 1000 // Increase radius by 1000 meters
    }
    
    private func decreaseRadius() {
        if notificationRadius > 1000 { // Ensure radius is not below a certain value (e.g., 1000 meters)
            notificationRadius -= 1000 // Decrease radius by 1000 meters
        }
    }
    
    var cancelButton: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var doneButton: some View {
        Button("Done") {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

enum CircleSize {
    case small, medium, large
}

struct AddLocationView_Previews: PreviewProvider {
    static var previews: some View {
        let selectedPerson = PeopleDataService.shared.people.first!
        return AddLocationView(person: selectedPerson)
    }
}


struct SearchBar: View {
    @Binding var text: String
    @State private var isVoiceDictationActive = false // Track voice dictation status
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .padding(.leading)
            
            TextField("Search or enter an address", text: $text, onEditingChanged: { isEditing in
                if isEditing {
                    // When editing begins, enable voice dictation
                    isVoiceDictationActive = true
                } else {
                    // When editing ends, disable voice dictation
                    isVoiceDictationActive = false
                }
            })
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            Button(action: {
                // Toggle voice dictation
                isVoiceDictationActive.toggle()
            }) {
                Image(systemName: isVoiceDictationActive ? "mic.fill" : "mic")
                    .padding(.trailing)
            }
            .disabled(isVoiceDictationActive) // Disable the button when voice dictation is active
        }
    }
}


struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}
