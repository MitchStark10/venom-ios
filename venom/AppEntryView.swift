//
//  ContentView.swift
//  venom
//
//  Created by Mitch Stark on 3/17/24.
//

import SwiftUI

struct AppEntryView: View {
    @EnvironmentObject var lists: Lists
    @EnvironmentObject var taskApi: TaskApi
    @EnvironmentObject var tagApi: TagApi
    
    @State private var hasSignedIn = initializeSignInStatus();
    @State private var path: NavigationPath = NavigationPath()
    @State private var currentViewLabel: String? = nil;
    @State private var isPresentingDeleteDialog = false;
    @State private var listIdToDelete: Int? = nil;

    @Environment (\.scenePhase) private var scenePhase;
    
    private let defaultMenuItems = [
        NavMenuItem(label: Constants.todayViewLabel),
        NavMenuItem(label: Constants.upcomingViewLabel),
        NavMenuItem(label: Constants.completedViewLabel)
    ];
    
    private let secondaryMenuItems = [
        NavMenuItem(label: Constants.tagsViewLabel)
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
                            
                            
                            if (lists.hasFetchedLists) {
                                Section(header: Text("Lists")) {
                                    ForEach(getMenuItems()) { menuItem in
                                        Button (menuItem.label) {
                                            path.append(menuItem.label)
                                        }.foregroundColor(Color(UIColor.label))
                                            .contextMenu(ContextMenu(menuItems: {
                                                Button("Update List") {
                                                    Task {
                                                        lists.showListModal = true;
                                                        lists.listToEdit = menuItem.list;
                                                    }
                                                }
                                                Button("Delete List", role: .destructive) {
                                                    isPresentingDeleteDialog = true;
                                                    listIdToDelete = menuItem.list?.id;
                                                }
                                            }))
                                    }
                                }
                            } else {
                                ProgressView()
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
                                
                                if (currentViewLabel == Constants.todayViewLabel) {
                                    await taskApi.fetchTodayTasks()
                                } else if (currentViewLabel == Constants.completedViewLabel) {
                                    await taskApi.fetchUpcomingTasks()
                                } else if (currentViewLabel == Constants.completedViewLabel) {
                                    await taskApi.fetchCompletedTasks()
                                } else if (currentViewLabel == Constants.tagsViewLabel) {
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
        }.sheet(isPresented: $lists.showListModal, onDismiss: {
            lists.showListModal = false;
        }) {
            CreateListModal(listToEdit: lists.listToEdit)
        }.confirmationDialog(
            "This will delete the list and all tasks in it. Are you sure you want to proceed?",
            isPresented: $isPresentingDeleteDialog
        ) {
            Button("Delete list and all tasks", role: .destructive) {
                Task {
                    await lists.deleteList(listId: listIdToDelete!)
                }
            }.onDisappear {
                listIdToDelete = nil;
            }
        }
    }
}
