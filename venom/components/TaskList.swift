//
//  TaskList.swift
//  venom
//
//  Created by Mitch Stark on 7/2/24.
//

import Foundation
import SwiftUI

struct TaskList: View {
    @EnvironmentObject var lists: Lists;
    @EnvironmentObject var taskApi: TaskApi;
    
    var taskItems: [VenomTask]
    var navTitle: String
    var groupBy: GroupByOptions = GroupByOptions.date;
    
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
        List {
            let taskItemsGroupedByDate = groupTasks(tasks: taskItems, groupBy: groupBy)
            
            ForEach(taskItemsGroupedByDate.keys.sorted(), id: \.self) { taskGroupKey in
                Section(header: Text(taskGroupKey)) {
                    ForEach(taskItemsGroupedByDate[taskGroupKey] ?? []) { task in
                        HStack {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    Task {
                                        await handleTaskCheck(task: task)
                                    }
                                }
                            Text(task.taskName)
                                .strikethrough(task.isCompleted, color: .black).onTapGesture {
                                    taskApi.taskToEdit = task;
                                    taskApi.showTaskModal = true;
                                }
                        }
                    }
                }
            }
        }.navigationTitle(navTitle)
    }
}

struct Preview: PreviewProvider {
    static var previews: some View {
        NavigationLink(destination: SubViewRouter(navMenuItem: NavMenuItem(label: "Test", list: VenomList(id: 1, order: 1, listName: "test", tasks: [])))) {
            Text("test")
        }
    }
}
