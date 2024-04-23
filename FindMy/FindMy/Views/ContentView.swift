//
//  ContentView.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/16/24.
//

import SwiftUI
import Combine
import MapKit

struct ContentView: View {
    @StateObject var deviceViewModel = DeviceListViewModel()
    @StateObject var personViewModel = PersonListViewModel()
    @StateObject var itemViewModel = ItemListViewModel()
    //@State private var position = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // BottomSheetView
            BottomSheetView(deviceViewModel: deviceViewModel, personViewModel: personViewModel, itemViewModel: itemViewModel)
        }
    }
}



#Preview {
    ContentView()
}
