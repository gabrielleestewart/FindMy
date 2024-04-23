//
//  ItemListViewModel.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/16/24.
//

import Foundation

class ItemListViewModel: ObservableObject {
    @Published var items: [Item]
    
    init(items: [Item] = []) {
        self.items = items
    }
}
