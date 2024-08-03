//
//  ContentView.swift
//  venom
//
//  Created by Mitch Stark on 3/17/24.
//

import SwiftUI

struct AppEntryView: View {
    @State private var hasSignedIn = initializeSignInStatus();
    @EnvironmentObject var lists: Lists
    @EnvironmentObject var taskApi: TaskApi
    @EnvironmentObject var tagApi: TagApi
    @State private var path: NavigationPath = NavigationPath()
    @State private var currentViewLabel: String? = nil;
    @Environment (\.scenePhase) private var scenePhase;
    
    private let defaultMenuItems = [
        NavMenuItem(label: "Today"),
        NavMenuItem(label: "Upcoming"),
        NavMenuItem(label: "Completed")
    ];
    
    private let secondaryMenuItems = [
        NavMenuItem(label: "Tags")
    ];
    
    private func getMenuItems() -> [NavMenuItem] {
        var menuItems: [NavMenuItem] = []
        for list in lists.lists {
            menuItems.append(NavMenuItem(label: list.listName, list: list))
        }
        
        return menuItems
    }
    
    func getAllMenuItems() -> [NavMenuItem] {
        return defaultMenuItems + secondaryMenuItems + getMenuItems();
    }
    
    var body: some View {
        VStack {
            if (!hasSignedIn) {
                LoginSignUp(hasSignedIn: $hasSignedIn)
            } else {
                ZStack(alignment: .bottomTrailing) {
                    NavigationStack(path: $path) {
                        List {
                            ForEach(defaultMenuItems) { menuItem in
                                Button(menuItem.label) {
                                    path.append(menuItem.label)
                                }.foregroundColor(Color(UIColor.label))
                            }
                            
                            Section {
                                ForEach(secondaryMenuItems) { menuItem in
                                    Button(menuItem.label) {
                                        path.append(menuItem.label)
                                    }.foregroundColor(Color(UIColor.label))
                                }
                            }
                            
                            
                            Section(header: Text("Lists")) {
                                ForEach(getMenuItems()) { menuItem in
                                    Button (menuItem.label) {
                                        path.append(menuItem.label)
                                    }.foregroundColor(Color(UIColor.label))
                                        .contextMenu(ContextMenu(menuItems: {
                                            Button("Delete List") {
                                                Task {
                                                    await lists.deleteList(listId: menuItem.list!.id)
                                                }
                                            }
                                        }))
                                }
                            }
                        }
                        .navigationTitle("Home")
                        .navigationDestination(for: String.self) { viewLabel in
                            let associatedNavMenuItem = getAllMenuItems().first(where: { $0.label == viewLabel })
                            if (associatedNavMenuItem != nil) {
                                SubViewRouter(navMenuItem: associatedNavMenuItem!).onAppear {
                                    currentViewLabel = viewLabel
                                }.onDisappear {
                                    currentViewLabel = nil
                                }
                            }
                        }
                        
                    }.onAppear {
                        Task {
                            await lists.fetchLists()
                            await tagApi.fetchTags()
                        }
                    }.onChange(of: scenePhase) { oldPhase, newPhase in
                        if (newPhase == .active) {
                            Task {
                                await lists.fetchLists()
                                
                                if (currentViewLabel == "Today") {
                                    await taskApi.fetchTodayTasks()
                                } else if (currentViewLabel == "Upcoming") {
                                    await taskApi.fetchUpcomingTasks()
                                } else if (currentViewLabel == "Completed") {
                                    await taskApi.fetchCompletedTasks()
                                } else if (currentViewLabel == "Tags") {
                                    await tagApi.fetchTags()
                                }
                            }
                        }
                    }
                    
                    if (currentViewLabel != "Completed") {
                        NewTaskFAB()
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $taskApi.showTaskModal, onDismiss: {
            taskApi.taskToEdit = nil;
            taskApi.showTaskModal = false;
        }) {
            CreateTaskModal(task: taskApi.taskToEdit, currentViewLabel: currentViewLabel)
        }.sheet(isPresented: $lists.showNewListModal, onDismiss: {
            lists.showNewListModal = false;
        }) {
            CreateListModal()
        }
    }
}
