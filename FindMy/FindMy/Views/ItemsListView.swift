//
//  ItemsListView.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/16/24.
//

import Combine
import SwiftUI
import MapKit

struct ItemsListView: View {
    @ObservedObject var viewModel: ItemListViewModel
    @State private var cityStateMap: [UUID: String] = [:]
    @State private var userLocation: CLLocationCoordinate2D? = nil
    @State private var locationTimestamps: [UUID: Date] = [:]
    @State private var cancellables = Set<AnyCancellable>() // Store subscriptions
    
    var body: some View {
        NavigationView {
            List(ItemsDataService.shared.items, id: \.id) { item in
                NavigationLink(destination: ItemDetailView(item: item)) {
                    HStack {
                        Image(item.profilePic)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text("\(cityStateMap[item.id, default: "Locating..."]) • \(locationTimestamp(for: item))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        if let userLocation = userLocation {
                            Text("\(distance(from: userLocation, to: item.location), specifier: "%.2f") mi")
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
                Text("Items")
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
                for item in ItemsDataService.shared.items {
                    fetchCityState(for: item)
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
    
    private func fetchCityState(for item: Item) {
        ItemsDataService.shared.cityAndState(for: item) { cityState in
            DispatchQueue.main.async {
                if cityState.isEmpty {
                    cityStateMap[item.id] = "No Location Found"
                } else {
                    cityStateMap[item.id] = cityState
                }
                locationTimestamps[item.id] = Date()
            }
        }
    }
    
    private func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation) / 1609.34 // Convert meters to miles
    }
    
    private func locationTimestamp(for item: Item) -> String {
        guard let timestamp = locationTimestamps[item.id] else {
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

struct ItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsListView(viewModel: ItemListViewModel(items: ItemsDataService.shared.items))
    }
}
