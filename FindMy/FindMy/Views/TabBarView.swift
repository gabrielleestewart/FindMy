//
//  TabBarView.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/16/24.
//

// TabBarView.swift
import SwiftUI

struct TabBarView: View {
    @State var presentSheet = true
    
    var body: some View {
        VStack {
            Spacer()
            TabView {
                PeopleListView(viewModel: PersonListViewModel())
                    .tabItem {
                        Image(systemName: "figure.2")
                        Text("People")
                    }
                    .sheet(isPresented: $presentSheet) {
                        PeopleListView(viewModel: PersonListViewModel())
                            .presentationDetents([.medium, .large, .height(50)])
                    }
                DevicesListView(viewModel: DeviceListViewModel())
                    .tabItem {
                        Image(systemName: "macbook.and.iphone")
                        Text("Devices")
                    }
                    .sheet(isPresented: $presentSheet) {
                        DevicesListView(viewModel: DeviceListViewModel())
                            .presentationDetents([.medium, .large, .height(50)])
                    }
                
                ItemsListView(viewModel: ItemListViewModel())
                    .tabItem {
                        Image(systemName: "circle.grid.2x2.fill")
                        Text("Items")
                    }
                    .sheet(isPresented: $presentSheet) {
                        ItemsListView(viewModel: ItemListViewModel())
                            .presentationDetents([.medium, .large, .height(50)])
                    }
                
                MeView()
                    .tabItem {
                        Image(systemName: "person.circle.fill")
                        Text("Me")
                    }
                    .sheet(isPresented: $presentSheet) {
                        MeView()
                            .presentationDetents([.medium, .large, .height(50)])
                    }
            }
            .frame(height: 70)
            .background(Color.white)
        }
    }
}


#Preview {
    TabBarView()
}
