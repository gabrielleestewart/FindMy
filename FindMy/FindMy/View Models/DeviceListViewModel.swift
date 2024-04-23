//
//  DeviceListViewModel.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/16/24.
//

import Foundation
import Combine

class DeviceListViewModel: ObservableObject {
    var coordinatesPublisher = PassthroughSubject<(lat: Double, lon: Double), Never>()
    
    @Published var devices: [Device]
    
    init(devices: [Device] = []) {
        self.devices = devices
    }
}
