//
//  TaskList.swift
//  venom
//
//  Created by Mitch Stark on 7/2/24.
//

import Foundation
import SwiftUI

struct TaskList: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var lists: Lists;
    @EnvironmentObject var taskApi: TaskApi;
    
    var taskItems: [VenomTask]
    var navTitle: String
    var groupBy: GroupByOptions = GroupByOptions.date;
    var showListName = false;
    var showDeleteTasksButton = false;
    
    private func handleTaskCheck(task: VenomTask) async {
        task.isCompleted = !task.isCompleted;
        let updateTaskResposne = await taskApi.updateTask(task:task, lists:lists);
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            Task {
                if (!updateTaskResposne) {
                    task.isCompleted = !task.isCompleted;
                } else if (navTitle == "Today") {
                    await taskApi.fetchTodayTasks()
                } else if (navTitle == "Upcoming") {
                    await taskApi.fetchUpcomingTasks()
                } else if (navTitle == "Completed") {
                    await taskApi.fetchCompletedTasks()
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if (taskItems.count == 0) {
                Text("No tasks found").padding()
            }
            
            List {
                let taskItemsGroupedByDate = groupTasks(tasks: taskItems, groupBy: groupBy)
                
                ForEach(taskItemsGroupedByDate.keys.sorted(), id: \.self) { taskGroupKey in
                    Section(header: Text(taskGroupKey)) {
                        ForEach(taskItemsGroupedByDate[taskGroupKey] ?? []) { task in
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .onTapGesture {
                                            Task {
                                                await handleTaskCheck(task: task)
                                            }
                                        }
                                    Text(task.taskName)
                                        .strikethrough(task.isCompleted, color: strikethroughColor)
                                }
                                
                                if (showListName && task.list != nil) {
                                    Text(task.list!.listName)
                                        .font(.caption)
                                        .padding(.top, 2)
                                        .padding(.leading, 30)
                                }
                            }.frame(maxWidth: .infinity, alignment: .topLeading)
                                .onTapGesture {
                                    taskApi.taskToEdit = task;
                                    taskApi.showTaskModal = true;
                                }
                        }
                    }
                }
                if (showDeleteTasksButton && taskItems.count > 0) {
                    Button("Delete Completed Tasks") {
                        Task {
                            await taskApi.deleteCompletedTasks()
                        }
                    }.buttonStyle(BorderlessButtonStyle())
                }
            }
        }
        .navigationTitle(navTitle)
    }
    
    private var strikethroughColor: Color {
        colorScheme == .dark ? Color.white : Color.black
    }
}
