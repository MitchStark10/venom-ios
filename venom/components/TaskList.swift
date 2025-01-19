//
//  TaskList.swift
//  venom
//
//  Created by Mitch Stark on 7/2/24.
//

import Foundation
import SwiftUI

struct TaskList: View {
    @EnvironmentObject var listsApi: ListsApi
    @EnvironmentObject var taskApi: TaskApi
    
    var taskItems: [VenomTask]
    var navTitle: String
    var groupBy: GroupByOptions = GroupByOptions.date
    var showListName = false
    var showDeleteTasksButton = false
    var enableReordering = false
    
    private var shouldShowLoader: Bool {
        if
            (navTitle == Constants.todayViewLabel && !taskApi.hasFetchedTodayTasks) ||
                (navTitle == Constants.upcomingViewLabel && !taskApi.hasFetchedUpcomingTasks) ||
                (navTitle == Constants.completedViewLabel && !taskApi.hasFetchedCompletedTasks) ||
                (navTitle == Constants.standupViewLabel && !taskApi.hasFetchedStandupTasks) {
            return true
        }
        
        return false
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                if taskItems.count == 0 {
                    if shouldShowLoader {
                        ProgressView()
                    } else {
                        Text("No tasks found")
                    }
                }
                
                let taskItemsGroupedByDate = groupTasks(tasks: taskItems, groupBy: groupBy)
                
                ForEach(taskItemsGroupedByDate.keys.sorted(), id: \.self) { taskGroupKey in
                    Section(header: Text(getDateGroupHeader(for: taskGroupKey))) {
                        ForEach(taskItemsGroupedByDate[taskGroupKey] ?? []) { task in
                            TaskItem(task: task, showListName: showListName, navTitle: navTitle)
                        }.onMove(perform: enableReordering ? { source, newIndex in
                            move(
                                source: source,
                                newIndex: newIndex,
                                taskListSource: taskItemsGroupedByDate[taskGroupKey]
                            )
                        } : nil)
                    }
                }
                if showDeleteTasksButton && taskItems.count > 0 {
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
    
    private func move(source: IndexSet, newIndex: Int, taskListSource: [VenomTask]?) {
        if taskListSource == nil {
            return
        }
        
        var taskList = taskListSource!
        
        Task {
            guard let sourceIndex = source.first else { return }
            let insertIndex = sourceIndex > newIndex ? newIndex : newIndex - 1
            
            let task = taskList.remove(at: sourceIndex)
            taskList.insert(task, at: insertIndex)
            await taskApi.reorder(taskList: taskList, listsApi: listsApi)
        }
    }
}


