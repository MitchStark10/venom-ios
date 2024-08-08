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
    var showListName = false;
    var showDeleteTasksButton = false;
    
    private var shouldShowLoader: Bool {
        if (
            (navTitle == Constants.todayViewLabel && !taskApi.hasFetchedTodayTasks) ||
            (navTitle == Constants.upcomingViewLabel && !taskApi.hasFetchedUpcomingTasks) ||
            (navTitle == Constants.completedViewLabel && !taskApi.hasFetchedCompletedTasks)
        ) {
            return true;
        }
        
        return false;
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                if (taskItems.count == 0) {
                    if (shouldShowLoader) {
                        ProgressView()
                    } else {
                        Text("No tasks found")
                    }
                }
                
                let taskItemsGroupedByDate = groupTasks(tasks: taskItems, groupBy: groupBy)
                
                ForEach(taskItemsGroupedByDate.keys.sorted(), id: \.self) { taskGroupKey in
                    Section(header: Text(taskGroupKey)) {
                        ForEach(taskItemsGroupedByDate[taskGroupKey] ?? []) { task in
                            TaskItem(task: task, showListName: showListName, navTitle: navTitle)
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
}


