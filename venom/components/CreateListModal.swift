//
//  CreateListModal.swift
//  venom
//
//  Created by Mitch Stark on 7/21/24.
//

import Foundation
import SwiftUI

struct CreateListModal: View {
    @EnvironmentObject var lists: Lists;
    @State var listName = ""
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField(text: $listName, prompt: Text("List Name"), axis: .vertical) {
                        Text("List Name")
                    }
                    
                    HStack {
                        Button(action: {
                            lists.showNewListModal = false
                        }) {
                            Text("Dismiss")
                        }.buttonStyle(BorderlessButtonStyle()).padding()
                        
                        Spacer()
                        
                        Button(action: {
                            Task {
                                await lists.createList(listName: listName)
                                lists.showNewListModal = false;
                            }
                        }) {
                            Text("Save")
                        }
                        .buttonStyle(BorderedButtonStyle())
                        .disabled(isDisabled)
                    }
                }
            }
        }
    }
    
    
    var isDisabled: Bool {
        return listName.isEmpty;
    }
    
    var buttonBackgroundColor: Color {
        return isDisabled ? Color.gray : Color.blue;
    }
    
    var buttonForegroundColor: Color {
        return isDisabled ? Color.black : Color.white;
    }
}
