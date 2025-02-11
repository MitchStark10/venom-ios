//
//  TaskItem.swift
//  venom
//
//  Created by Mitch Stark on 7/22/24.
//

import Foundation
import SwiftUI

let rightAlignmentWidth: CGFloat = 40;

struct TaskItem: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var taskApi: TaskApi;
    @EnvironmentObject var listsApi: ListsApi;
    @EnvironmentObject var settingsApi: SettingsApi;
    
    
    let task: VenomTask
    let showListName: Bool
    let navTitle: String
    @State var isOn: Bool
    

    init(task: VenomTask, showListName: Bool, navTitle: String) {
        self.showListName = showListName;
        self.task = task;
        self.navTitle = navTitle;
        self.isOn = task.isCompleted;
    }

    private func handleTaskCheck() async {
        task.isCompleted = !task.isCompleted;
        if (task.isCompleted) {
            task.dateCompleted = formatDate(dateToFormat: Date())
        } else {
            task.dateCompleted = nil
        }
        let updateTaskResposne = await taskApi.updateTask(task:task, listsApi: listsApi);
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            Task {
                if (!updateTaskResposne) {
                    task.isCompleted = !task.isCompleted;
                } else if (navTitle == Constants.todayViewLabel) {
                    await taskApi.fetchTodayTasks()
                } else if (navTitle == Constants.upcomingViewLabel) {
                    await taskApi.fetchUpcomingTasks()
                } else if (navTitle == Constants.completedViewLabel) {
                    await taskApi.fetchCompletedTasks()
                } else if (navTitle == Constants.standupViewLabel) {
                    await taskApi.fetchStandupTasks(isIgnoringWeekends: settingsApi.dailyReportIgnoreWeekends)
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Toggle(isOn: $isOn) {
                    Text(task.taskName).strikethrough(isOn, color: strikethroughColor).padding(.leading, 5)
                }.toggleStyle(CheckboxToggleStyle(onTap: {
                    Task {
                        await handleTaskCheck()
                    }
                }))
            }
            
            HStack(spacing: 8) {
                if (showListName && task.list != nil) {
                    Text(task.list!.listName).font(.caption).bold()
                }
                
                if (task.taskTag?.isEmpty == false) {
                    ForEach(task.taskTag!) { taskTag in
                        Flag(tag: taskTag.tag)
                    }
                }
            }
            .padding(.leading, rightAlignmentWidth)
        }
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .onTapGesture {
            taskApi.taskToEdit = task;
            taskApi.showTaskModal = true;
        }
    }
    
    private var strikethroughColor: Color {
        colorScheme == .dark ? Color.white : Color.black
    }
}
