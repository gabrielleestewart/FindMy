//
//  ItemDetailView.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/16/24.
//

import SwiftUI
import MapKit

struct ItemDetailView: View {
    let item: Item
    let selectedItem = ItemsDataService.shared.items.first!
    @State private var locShare = true
    @State private var friendReq = true
    @State private var fav = false
    @State private var userLocation: CLLocationCoordinate2D? = nil
    @Environment(\.presentationMode) var presentationMode
    @State private var isLocationDetailViewActive = false
    @State private var isNotificationViewActive = false
    @State private var showingRemoveItemActionSheet = false
    @StateObject var notificationSettingsViewModel = NotificationViewModel(notificationSettings: [])
    @State private var showPopover = false
    @State private var sound = false
    @State private var lost = false
    
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    VStack(alignment: .leading) {
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(.purple)
                            .font(.system(size: 30))
                            .padding(.bottom, 10)
                        Text("Play Sound")
                            .bold()
                        if sound == false {
                            Button(action: {
                                sound = true
                            }) {
                                Text("On")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            Button(action: {
                                sound = false
                            }) {
                                Text("Off")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
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
                        Text("0 mi")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
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
                }
                    Section {
                        VStack(alignment: .leading) {
                            Image(systemName: "lock.circle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 30))
                                .padding(.bottom, 10)
                            Text("Mark As Lost")
                                .bold()
                        }
                            if lost == false {
                                Button(action: {
                                    lost = true
                                }) {
                                    Text("Activate")
                                        .foregroundColor(.blue)
                                }
                            } else {
                                Button(action: {
                                    lost = false
                                }) {
                                    Text("Lost Mode Activated")
                                        .foregroundColor(.red)
                                }
                            }
                        
                }
                
                Section {
                    Button(action: {
                        showStopSharingLocationAlert()
                    }) {
                        Text("Erase this Item")
                            .foregroundColor(.red)
                    }
                }
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                HStack {
            Text(item.name)
                .font(.title2)
                .padding(.leading, 10)
                .bold()
        },
                            trailing: cancelButton)
        
    }
    private var cancelButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
            
        }) {
            Image(systemName: "x.circle.fill")
        }
    }
    
    func showStopSharingLocationAlert() {
        let alertController = UIAlertController(title: "Are you sure you want to erase this item?", message: nil, preferredStyle: .alert)
        let stopSharingAction = UIAlertAction(title: "Erase this Item", style: .destructive) { _ in
            ItemsDataService.shared.removeItem(item)
            presentationMode.wrappedValue.dismiss()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        
        alertController.addAction(stopSharingAction)
        alertController.addAction(cancelAction)
        
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let selectedItem = ItemsDataService.shared.items.first!
        
        return NavigationView {
            ItemDetailView(item: selectedItem)
        }
    }
}
