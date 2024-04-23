// MapView.swift
// FindMy
//
// Created by Gabrielle Stewart on 4/17/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var peopleDataService = PeopleDataService.shared
    @State private var selectedPerson: Person? = nil // Track selected person
    
    var body: some View {
        ZStack {
            Map(position: .constant(.automatic),
                bounds: nil,
                interactionModes: .all,
                scope: nil) {
                ForEach(peopleDataService.people, id: \.id) { person in
                    Annotation("", coordinate: person.location) {
                        VStack {
                            Image(person.profilePic)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 3)
                                )
                        }
                        .onTapGesture {
                            self.selectedPerson = person // Set selected person on tap
                        }
                    }
                    .annotationTitles(.hidden)
                    .annotationSubtitles(.hidden)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .sheet(item: $selectedPerson) { person in
            PersonDetailView(person: person)
        }
    }
    
    // Move the position function outside the body property
    func position(for coordinate: CLLocationCoordinate2D, in size: CGSize) -> CGPoint {
        let mapPoint = MKMapPoint(coordinate)
        return CGPoint(x: mapPoint.x / Double(size.width), y: mapPoint.y / Double(size.height))
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
