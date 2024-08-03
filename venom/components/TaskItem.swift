//
//  TaskItem.swift
//  venom
//
//  Created by Mitch Stark on 7/22/24.
//

import Foundation
import SwiftUI

let rightAlignmentWidth: CGFloat = 30;

struct TaskItem: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var taskApi: TaskApi;
    @EnvironmentObject var lists: Lists;
    
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
            HStack {
                Toggle(isOn: $isOn) {
                    Text(task.taskName).strikethrough(isOn, color: strikethroughColor)
                }.toggleStyle(CheckboxToggleStyle(onTap: {
                    Task {
                        await handleTaskCheck()
                    }
                }))
            }
            
            if (task.taskTag?.isEmpty == false) {
                HStack(spacing: 4) {
                    ForEach(task.taskTag!) { taskTag in
                        Flag(tag: taskTag.tag)
                    }
                }
                .padding(.leading, rightAlignmentWidth)
            }
            
            if (showListName && task.list != nil) {
                Text(task.list!.listName)
                    .font(.caption)
                    .padding(.top, 2)
                    .padding(.leading, rightAlignmentWidth)
            }
        }
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
