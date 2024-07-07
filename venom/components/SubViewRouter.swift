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
                TaskList(taskItems: taskApi.todayTasks, navTitle: navMenuItem.label).onAppear {
                    Task {
                        await taskApi.fetchTodayTasks()
                    }
                }
            } else {
                Text(navMenuItem.label)
            }
        }
    }
}
