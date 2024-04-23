//
//  PersonDetailView.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/16/24.
//

import SwiftUI
import MapKit
import UIKit
import ContactsUI

struct PersonDetailView: View {
    let person: Person
    let selectedPerson = PeopleDataService.shared.people.first!
    @State private var locShare = true
    @State private var friendReq = true
    @State private var fav = false
    @State private var selectedNickname: Nickname?
    @Environment(\.presentationMode) var presentationMode
    @State private var isLocationDetailViewActive = false
    @State private var isNotificationViewActive = false
    @State private var isNotifyMeActive = false
    @State private var isNotifyPersonActive = false
    @State private var showingRemovePersonActionSheet = false
    @StateObject var notificationSettingsViewModel = NotificationViewModel(notificationSettings: [])
    @State private var showPopover = false
    
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    VStack(alignment: .leading) {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 30))
                            .padding(.bottom, 10)
                        Text("Contact")
                            .bold()

                        Button(action: {
                            openContact(for: person.name)
                        }) {
                            Text("")
                        }
                    }
                }
                
                Section {
                    VStack(alignment: .leading) {
                        Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 30))
                            .padding(.bottom, 10)
                        Text("Directions")
                            .bold()
                        //the distance this person is from the user (current location) should be added to the text below in miles.
                        Text(" mi")
                            .foregroundColor(.secondary)
                    }
                }
                
                
                Section {
                    VStack(alignment: .leading) {
                        Image(systemName: "bell.circle.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 30))
                            .padding(.bottom, 10)
                        Text("Notifications")
                            .bold()
                    }
                    
                    Menu {
                        Button(action: {
                            self.isNotificationViewActive = true // This will open the notification settings for "Notify Me"
                        }) {
                            Label("Notify Me", systemImage: "bell.fill")
                        }
                        .sheet(isPresented: $isNotificationViewActive) {
                            NotificationSettingsView(person: selectedPerson, viewModel: NotificationViewModel(notificationSettings: selectedPerson.notificationSettings))
                        }
                        
                        Button(action: {
                            self.isNotificationViewActive = true // This will open the notification settings for "Notify \(person.name)"
                        }) {
                            Label("Notify \(person.name)", systemImage: "bell.fill")
                        }
                        .sheet(isPresented: $isNotificationViewActive) {
                            NotificationSettingsView(person: selectedPerson, viewModel: NotificationViewModel(notificationSettings: selectedPerson.notificationSettings))
                        }
                    } label: {
                    Text("Add")
                        .foregroundColor(.blue)
                    }
                }
                
                
                Section {
                    if fav == false {
                        Button(action: {
                            fav = true
                        }) {
                            Text("Add \(person.name) to Favorites")
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button(action: {
                            fav = false
                        }) {
                            Text("Remove \(person.name) from Favorites")
                                .foregroundColor(.red)
                        }
                    }
                    
                    Button(action: {
                        self.isLocationDetailViewActive = true
                    }) {
                        Text("Edit Location Name")
                    }
                    .sheet(isPresented: $isLocationDetailViewActive) {
                        LocationDetailView(selectedNickname: $selectedNickname)
                    }
                    
                    Button(action: {
                        showStopSharingLocationAlert()
                    }) {
                        Text("Stop Sharing My Location")
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        showRemovePersonActionSheet()
                    }) {
                        Text("Remove \(person.name)")
                            .foregroundColor(.red)
                    }
                    .actionSheet(isPresented: $showingRemovePersonActionSheet) {
                        ActionSheet(
                            title: Text("Are you sure you want to remove \(person.name)?"),
                            buttons: [
                                .destructive(Text("Remove"), action: {
                                    // Handle removal here
                                    PeopleDataService.shared.removePerson(person)
                                    presentationMode.wrappedValue.dismiss()
                                }),
                                .cancel(Text("Cancel"))
                            ]
                        )
                    }
                    
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                                    HStack {
                Text(person.name)
                    .font(.title2)
                    .padding(.leading, 10)
                    .bold()
            },
                                trailing: cancelButton)
            
            .overlay(
                VStack {
                    Divider()
                        .padding(.top, -1)
                    Spacer()
                }
                    .frame(maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.top)
            )
            
        }
        .background(Color(.systemGray6))
    }
    
    func openContact(for name: String) {
        let contact = CNMutableContact()
        contact.givenName = name

        let controller = CNContactViewController(forUnknownContact: contact)
        controller.allowsActions = false
        controller.allowsEditing = false

        let navigationController = UINavigationController(rootViewController: controller)
        UIApplication.shared.windows.first?.rootViewController?.present(navigationController, animated: true, completion: nil)
    }
    
    func showStopSharingLocationAlert() {
        let alertController = UIAlertController(title: "Are you sure you want to stop sharing your location?", message: nil, preferredStyle: .alert)
        let stopSharingAction = UIAlertAction(title: "Stop Sharing Location", style: .destructive) { _ in
            PeopleDataService.shared.removePerson(person)
            presentationMode.wrappedValue.dismiss()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        
        alertController.addAction(stopSharingAction)
        alertController.addAction(cancelAction)
        
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showRemovePersonActionSheet() {
        showingRemovePersonActionSheet = true
    }
    
    
    private var cancelButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
            
        }) {
            Image(systemName: "x.circle.fill")
        }
    }
}



struct PersonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let selectedPerson = PeopleDataService.shared.people.first!
        
        return NavigationView {
            PersonDetailView(person: selectedPerson)
        }
    }
}
