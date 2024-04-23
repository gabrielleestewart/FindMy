//
//  ContactView.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/22/24.
//

import SwiftUI
import ContactsUI

struct ContactView: View {
    let person: Person
    let selectedPerson = PeopleDataService.shared.people.first!
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "person.circle.fill")
                .foregroundColor(.green)
                .font(.system(size: 30))
                .padding(.bottom, 10)
            Text("Contact")
                .bold()
            
            Button(action: {
                openContact(for: person.name)
            }) {
                Text("Open in Contacts")
                    .foregroundColor(.blue)
            }
        }
    }
    
    func openContact(for name: String) {
        let contact = CNMutableContact()
        contact.givenName = name
        
        let controller = CNContactViewController(forUnknownContact: contact)
        controller.allowsActions = false
        controller.allowsEditing = false
        
        let navigationController = UINavigationController(rootViewController: controller)
        UIApplication.shared.windows.first?.rootViewController?.present(navigationController, animated: true, completion: nil)
    }
}
