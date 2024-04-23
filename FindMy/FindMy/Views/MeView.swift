//
//  MeView.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/16/24.
//

import SwiftUI

struct MeView: View {
    @State private var locShare = true
    @State private var friendReq = true
    @State private var selectedNickname: Nickname?
    @State private var isLocationDetailViewActive = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .leading) {
                        Image(systemName: "location.circle.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 30))
                            .padding(.bottom, 10)
                        Text("My Location")
                            .bold()
                    }
                    
                    Button(action: {
                        self.isLocationDetailViewActive = true
                    }) {
                        HStack {
                            Text("Location")
                                .foregroundColor(.black)
                            Spacer()
                            if let nickname = selectedNickname {
                                Text(nickname.name)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Select >").foregroundColor(.gray)
                            }
                        }
                    }
                    .sheet(isPresented: $isLocationDetailViewActive) {
                        LocationDetailView(selectedNickname: $selectedNickname)
                    }
                    
                    HStack {
                        Text("From")
                        Spacer()
                        Text("This iPhone").foregroundColor(.gray)
                    }
                    Toggle("Share My Location", isOn: $locShare)
                    
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
                    Toggle("Allow Friend Requests", isOn: $friendReq)
                }
                
                Section {
                    Button(action: {
                        guard let findMySettingsURL = URL(string: UIApplication.openSettingsURLString + "&path=NOTIFICATIONS/Find_My") else { return }
                        UIApplication.shared.open(findMySettingsURL)
                    }) {
                        Text("Customize Find My Notifications")
                    }
                    Button(action: {
                        guard let trackingSettingsURL = URL(string: UIApplication.openSettingsURLString + "&path=NOTIFICATIONS/Tracking") else { return }
                        UIApplication.shared.open(trackingSettingsURL)
                    }) {
                        Text("Customize Tracking Notifications")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                HStack {
                    Text("Me")
                        .font(.title3)
                        .padding(.leading, 10)
                        .bold()
                }
            )
            .overlay(
                VStack {
                    Divider()
                        .padding(.top, -1)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .edgesIgnoringSafeArea(.top)
            )
            
            VStack {
                Button(action: {
                    guard let helpAFriendURL = URL(string: "https://www.icloud.com/find") else { return }
                    UIApplication.shared.open(helpAFriendURL)
                }) {
                    Text("Help a Friend")
                        .font(.subheadline)
                }
                .background(Color(.systemGray6))
                
                Text("Open iCloud.com so others can sign in and find their devices from this iPhone.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .background(Color(.systemGray6))
            .frame(maxWidth: .infinity)
        }
        .background(Color(.systemGray6))
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
