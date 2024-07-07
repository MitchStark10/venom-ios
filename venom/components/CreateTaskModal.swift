//
//  CreateTaskModal.swift
//  venom
//
//  Created by Mitch Stark on 7/3/24.
//

import Foundation
import SwiftUI

struct CreateTaskModal: View {
    @EnvironmentObject var lists: Lists;
    @EnvironmentObject var taskApi: TaskApi
    @Binding var isShowingNewTaskModal: Bool;
    @State var taskName = "";
    @State var listId: Int? = nil;
    @State private var dueDate = Date();
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Create New Task").font(.subheadline)) {
                    TextField(text: $taskName, prompt: Text("Task Name")) {
                        Text("Task Name")
                    }
                    DatePicker(
                        "Due Date",
                        selection: $dueDate,
                        displayedComponents: [.date]
                    )
                    if (listId != nil) {
                        Picker("List", selection: $listId) {
                            ForEach(lists.lists, id: \.self) { list in
                                Text(list.listName).tag(list.id as Int?)
                            }
                        }
                    }
                    HStack {
                        Button(action: {
                            isShowingNewTaskModal = false;
                        }) {
                            Text("Dismiss")
                        }.buttonStyle(BorderlessButtonStyle()).padding()
                        
                        Spacer()
                        
                        Button(action: {
                            Task {
                                if (listId == nil) {
                                    // TODO: Show some error message
                                    return;
                                }
                                await taskApi.createTask(taskName: taskName, dueDate: dueDate, listId: listId!, lists: lists)
                                isShowingNewTaskModal = false;
                            }
                        }) {
                            Text("Save")
                        }.buttonStyle(BorderedButtonStyle())
                        .disabled(isDisabled)
                    }
                }
            }
        }.onAppear {
            if (lists.lists.first != nil) {
                listId = lists.lists.first!.id
            }
        }
    }
    
    
    var isDisabled: Bool {
        return taskName.isEmpty || listId == nil;
    }
    
    var buttonBackgroundColor: Color {
        return isDisabled ? Color.gray : Color.blue;
    }
    
    var buttonForegroundColor: Color {
        return isDisabled ? Color.black : Color.white;
    }
}
