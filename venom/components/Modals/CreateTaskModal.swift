//
//  CreateTaskModal.swift
//  venom
//
//  Created by Mitch Stark on 7/3/24.
//

import Foundation
import SwiftUI

struct CreateTaskModal: View {
    @EnvironmentObject var listsApi: ListsApi
    @EnvironmentObject var taskApi: TaskApi
    @EnvironmentObject var tagApi: TagApi
    @EnvironmentObject var settingsApi: SettingsApi
    
    private var currentNavMenuitem: NavMenuItem?
    var task: VenomTask?
    
    @State var taskName: String
    @State var listId: Int?
    @State private var dueDate: Date
    @State private var selectedTagIds: Set<Int>
    @State private var useDatePicker: Bool
    @FocusState private var isTextFieldFocused: Bool
    
    init(task: VenomTask? = nil, currentNavMenuItem: NavMenuItem?) {
        self.task = task
        self.currentNavMenuitem = currentNavMenuItem
        self.taskName = task?.taskName ?? ""
        self.listId = task?.listId ?? nil
        
        if task?.tagIds != nil {
            self.selectedTagIds = Set(task!.tagIds)
        } else {
            self.selectedTagIds = []
        }
        
        if task?.dueDate != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.dueDate = dateFormatter.date(from: task!.dueDate!)!
            self.useDatePicker = true
        } else {
            self.dueDate = Date()
            self.useDatePicker = false
        }
    }
    
    var headerText: String {
        return self.task == nil ? "Create New Task" : "Edit Task"
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text(headerText).font(.subheadline)) {
                    Picker("List", selection: $listId) {
                        ForEach(listsApi.lists, id: \.self.id) { list in
                            Text(list.listName).tag(list.id as Int?)
                        }
                    }
                    TextField(text: $taskName, prompt: Text("Task Name"), axis: .vertical) {
                        Text("Task Name")
                    }
                    .focused($isTextFieldFocused)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            HStack {
                                Spacer()
                                Button("Done") {
                                    isTextFieldFocused = false
                                }
                            }
                        }
                    }
                    
                    Toggle("Due Date", isOn: $useDatePicker)
                    
                    if self.useDatePicker {
                        DatePicker(
                            "Due Date",
                            selection: $dueDate,
                            displayedComponents: [.date]
                        ).datePickerStyle(.graphical)
                    }
                    
                    MultiSelect(title: Constants.tagsViewLabel, items: tagApi.tags.map { tag in
                        return MultiSelectData(value: tag.id, label: tag.tagName)
                    }, selectedItems: $selectedTagIds)
                    
                    HStack {
                        Button(action: {
                            taskApi.taskToEdit = nil
                            taskApi.showTaskModal = false
                        }) {
                            Text("Dismiss")
                        }.buttonStyle(BorderlessButtonStyle()).padding()
                        Spacer()
                        Button(action: {
                            Task {
                                if listId == nil && task == nil {
                                    // TODO: Show some error message
                                    return
                                }
                                
                                if task != nil {
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd"
                                    if listId != nil {
                                        task!.listId = listId!
                                    }
                                    task!.taskName = taskName
                                    if useDatePicker {
                                        task!.dueDate = dateFormatter.string(from: self.dueDate)
                                    } else {
                                        task!.dueDate = nil
                                    }
                                    task!.tagIds = Array(selectedTagIds)
                                    
                                    await taskApi.updateTask(task: task!, listsApi: listsApi)
                                } else {
                                    await taskApi.createTask(taskName: taskName, dueDate: dueDate, listId: listId!, listsApi: listsApi, tagIds: Array(selectedTagIds))
                                }
                                taskApi.showTaskModal = false
                                taskApi.taskToEdit = nil
                                
                                if currentNavMenuitem?.label == Constants.todayViewLabel {
                                    await taskApi.fetchTodayTasks()
                                } else if currentNavMenuitem?.label == Constants.upcomingViewLabel {
                                    await taskApi.fetchUpcomingTasks()
                                } else if currentNavMenuitem?.label == Constants.completedViewLabel {
                                    await taskApi.fetchCompletedTasks()
                                } else if currentNavMenuitem?.label == Constants.standupViewLabel {
                                    await taskApi.fetchStandupTasks(isIgnoringWeekends: settingsApi.dailyReportIgnoreWeekends)
                                }
                            }
                        }) {
                            Text("Save")
                        }.buttonStyle(BorderedButtonStyle())
                        .disabled(isDisabled)
                    }
                }
            }
        }.onAppear {
            let defaultListId = currentNavMenuitem?.list?.id ?? listsApi.lists.first?.id ?? nil
            if defaultListId != nil && listId == nil {
                listId = defaultListId
            }
        }
    }
    
    
    var isDisabled: Bool {
        return taskName.isEmpty || listId == nil
    }
    
    var buttonBackgroundColor: Color {
        return isDisabled ? Color.gray : Color.blue
    }
    
    var buttonForegroundColor: Color {
        return isDisabled ? Color.black : Color.white
    }
}
