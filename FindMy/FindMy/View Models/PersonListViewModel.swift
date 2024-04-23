//
//  PersonListViewModel.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/16/24.
//

import Foundation

class PersonListViewModel: ObservableObject {
    @Published var people: [Person]
    
    init(people: [Person] = []) {
        self.people = people
    }
}
