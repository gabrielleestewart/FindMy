//
//  DeviceListView.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/16/24.
//

import Combine
import SwiftUI
import MapKit

struct DevicesListView: View {
    @ObservedObject var viewModel: DeviceListViewModel
    @State private var cityStateMap: [UUID: String] = [:]
    @State private var userLocation: CLLocationCoordinate2D? = nil
    @State private var locationTimestamps: [UUID: Date] = [:]
    @State private var cancellables = Set<AnyCancellable>() // Store subscriptions
    
    var body: some View {
        NavigationView {
            List(DevicesDataService.shared.devices, id: \.id) { device in
                NavigationLink(destination: DeviceDetailView(device: device)) {
                    HStack {
                        Image(device.profilePic)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                        VStack(alignment: .leading) {
                            Text(device.name)
                                .font(.headline)
                            Text("\(cityStateMap[device.id, default: "Locating..."]) • \(locationTimestamp(for: device))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        if let userLocation = userLocation {
                            Text("\(distance(from: userLocation, to: device.location), specifier: "%.2f") mi")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                                    HStack {
                Text("Devices")
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
            .onAppear {
                for device in DevicesDataService.shared.devices {
                    fetchCityState(for: device)
                }
                
                DeviceLocationService.shared.requestLocationUpdates()
                
                DeviceLocationService.shared.coordinatesPublisher
                    .sink(receiveCompletion: { _ in },
                          receiveValue: { coordinates in
                        self.userLocation = coordinates
                    })
                    .store(in: &cancellables)
            }
        }
    }
    
    private func fetchCityState(for device: Device) {
        DevicesDataService.shared.cityAndState(for: device) { cityState in
            DispatchQueue.main.async {
                if cityState.isEmpty {
                    cityStateMap[device.id] = "No Location Found"
                } else {
                    cityStateMap[device.id] = cityState
                }
                locationTimestamps[device.id] = Date()
            }
        }
    }
    
    private func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation) / 1609.34 // Convert meters to miles
    }
    
    private func locationTimestamp(for device: Device) -> String {
        guard let timestamp = locationTimestamps[device.id] else {
            return "Now"
        }
        
        let timeDifference = Calendar.current.dateComponents([.minute, .hour, .day], from: timestamp, to: Date())
        
        if let minutes = timeDifference.minute, minutes == 0 {
            return "Now"
        } else if let minutes = timeDifference.minute, minutes < 60 {
            return "\(minutes) min. ago"
        } else if let hours = timeDifference.hour, hours < 24 {
            return "\(hours) hour\(hours > 1 ? "s." : ".") ago"
        } else if let days = timeDifference.day {
            return "\(days) day\(days > 1 ? "s." : ".") ago"
        } else {
            return ""
        }
    }
}

struct DevicesListView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesListView(viewModel: DeviceListViewModel(devices: DevicesDataService.shared.devices))
    }
}
