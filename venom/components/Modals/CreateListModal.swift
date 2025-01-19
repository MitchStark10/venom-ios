//
//  CreateListModal.swift
//  venom
//
//  Created by Mitch Stark on 7/21/24.
//

import Foundation
import SwiftUI

struct CreateListModal: View {
    @EnvironmentObject var listsApi: ListsApi;
    @State var listName: String;
    var listToEdit: VenomList?
    
    public init(listToEdit: VenomList?) {
        self.listToEdit = listToEdit;
        
        if (listToEdit != nil) {
            self.listName = listToEdit!.listName;
        } else {
            self.listName = "";
        }
    }
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField(text: $listName, prompt: Text("List Name"), axis: .vertical) {
                        Text("List Name")
                    }
                    
                    HStack {
                        Button(action: {
                            listsApi.showListModal = false
                        }) {
                            Text("Dismiss")
                        }.buttonStyle(BorderlessButtonStyle()).padding()
                        
                        Spacer()
                        
                        Button(action: {
                            Task {
                                if (listToEdit != nil) {
                                    listToEdit!.listName = listName;
                                    await listsApi.updateList(list: listToEdit!);
                                } else {
                                    await listsApi.createList(listName: listName);
                                }
                                
                                listsApi.listToEdit = nil;
                                listsApi.showListModal = false;
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
