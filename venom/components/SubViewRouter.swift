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
    @EnvironmentObject var tagApi: TagApi;
    let navMenuItem: NavMenuItem;
    
    var body: some View {
        VStack {
            if (navMenuItem.list != nil) {
                TaskList(taskItems: navMenuItem.list?.tasks ?? [], navTitle: navMenuItem.label, enableReordering: true)
            } else if (navMenuItem.label == Constants.todayViewLabel) {
                TaskList(taskItems: taskApi.todayTasks, navTitle: navMenuItem.label, groupBy: GroupByOptions.list).onAppear {
                    Task {
                        await taskApi.fetchTodayTasks()
                    }
                }
            } else if (navMenuItem.label == Constants.upcomingViewLabel) {
                TaskList(taskItems: taskApi.upcomingTasks, navTitle: navMenuItem.label, showListName: true).onAppear {
                    Task {
                        await taskApi.fetchUpcomingTasks()
                    }
                }
            } else if (navMenuItem.label == Constants.completedViewLabel) {
                VStack {
                    TaskList(taskItems: taskApi.completedTasks, navTitle: navMenuItem.label, showListName: true, showDeleteTasksButton: true).onAppear {
                        Task {
                            await taskApi.fetchCompletedTasks()
                        }
                    }
                }
            } else if (navMenuItem.label == Constants.tagsViewLabel) {
                TagList().onAppear {
                    Task {
                        await tagApi.fetchTags();
                    }
                }
            } else if (navMenuItem.label == Constants.standupViewLabel) {
                TaskList(taskItems: taskApi.standupTasks, navTitle: navMenuItem.label, groupBy: GroupByOptions.customGroup, showListName: true, showDeleteTasksButton: false).onAppear {
					Task {
						await taskApi.fetchStandupTasks()
					}
				}
            } else {
                Text(navMenuItem.label)
            }
        }
    }
}
