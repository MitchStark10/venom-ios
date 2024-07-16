//
//  SubViewRouter.swift
//  venom
//
//  Created by Mitch Stark on 7/2/24.
//

import Foundation
import SwiftUI

struct SubViewRouter: View {
    @EnvironmentObject var taskApi: TaskApi;
    let navMenuItem: NavMenuItem;
    
    var body: some View {
        VStack {
            if (navMenuItem.list != nil) {
                TaskList(taskItems: navMenuItem.list?.tasks ?? [], navTitle: navMenuItem.label)
            } else if (navMenuItem.label == "Today") {
                TaskList(taskItems: taskApi.todayTasks, navTitle: navMenuItem.label, groupBy: GroupByOptions.list).onAppear {
                    Task {
                        await taskApi.fetchTodayTasks()
                    }
                }
            } else if (navMenuItem.label == "Upcoming") {
                TaskList(taskItems: taskApi.upcomingTasks, navTitle: navMenuItem.label).onAppear {
                    Task {
                        await taskApi.fetchUpcomingTasks()
                    }
                }
            } else {
                Text(navMenuItem.label)
            }
        }
    }
}
