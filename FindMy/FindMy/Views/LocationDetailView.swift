//
//  LocationDetailView.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/16/24.
//

import SwiftUI

public struct LocationDetailView: View {
    @Binding var selectedNickname: Nickname?
    @State private var customNickname: String = ""
    @State private var customNicknames: [Nickname] = []
    @Environment(\.presentationMode) var presentationMode
    @State private var isEditing = false
    
    init(selectedNickname: Binding<Nickname?>) {
        self._selectedNickname = selectedNickname
    }
    
    public var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(selection: $selectedNickname, label:
                        HStack {
                            VStack(alignment: .leading) {
                                Image(systemName: "tag.circle.fill")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 30))
                                    .padding(.bottom, 10)
                                Text("Location Name")
                                    .bold()
                            }
                            Spacer()
                        }
                    ) {
                        ForEach(presetNicknames + customNicknames, id: \.self) { nickname in
                            Text(nickname.name)
                                .tag(nickname as Nickname?)
                        }
                    }
                }
                .pickerStyle(.inline)
                
                Section() {
                    List {
                        ForEach(customNicknames, id: \.self) { nickname in
                            if isEditing {
                                HStack {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                        .onTapGesture {
                                            if let index = customNicknames.firstIndex(of: nickname) {
                                                customNicknames.remove(at: index)
                                            }
                                        }
                                    Text(nickname.name)
                                }
                            } else {
                                Text(nickname.name)
                                    .tag(nickname as Nickname?)
                            }
                        }
                        .onDelete(perform: deleteCustomNickname)
                    }
                    
                    ZStack(alignment: .leading) {
                        if customNickname.isEmpty {
                            Text("Add Custom Label")
                                .foregroundColor(.blue)
                        }
                        TextField("", text: $customNickname, onCommit: saveCustomNickname)
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: cancelButton, trailing: editButton)
        }
    }
    
    private func saveCustomNickname() {
        let trimmedCustomNickname = customNickname.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedCustomNickname.isEmpty else {
            return
        }
        customNicknames.append(Nickname(name: trimmedCustomNickname))
        customNickname = ""
    }
    
    private func deleteCustomNickname(at offsets: IndexSet) {
        customNicknames.remove(atOffsets: offsets)
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private var editButton: some View {
        Button(action: {
            isEditing.toggle()
        }) {
            Text(isEditing ? "Done" : "Edit")
        }
    }
    
    private var presetNicknames: [Nickname] = [
        Nickname(name: "Home"),
        Nickname(name: "Work"),
        Nickname(name: "School"),
        Nickname(name: "Gym"),
        Nickname(name: "Other")
    ]
}

struct Nickname: Hashable {
    let name: String
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailView(selectedNickname: .constant(nil))
    }
}
