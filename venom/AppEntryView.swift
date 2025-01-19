//
//  ContentView.swift
//  venom
//
//  Created by Mitch Stark on 3/17/24.
//

import SwiftUI
import UIKit

struct AppEntryView: View {
    @EnvironmentObject var listsApi: ListsApi
    @EnvironmentObject var taskApi: TaskApi
    @EnvironmentObject var tagApi: TagApi
    @EnvironmentObject var loginSignUpApi: LoginSignUpApi
    @EnvironmentObject var settingsApi: SettingsApi
    @EnvironmentObject var globalMessages: GlobalMessages
    
    @State private var path: NavigationPath = NavigationPath()
    @State private var currentNavMenuItem: NavMenuItem?
    @State private var isPresentingDeleteDialog = false
    @State private var listIdToDelete: Int?

    @Environment(\.scenePhase) private var scenePhase
    
    private let defaultMenuItems = [
        NavMenuItem(label: Constants.todayViewLabel),
		NavMenuItem(label: Constants.standupViewLabel),
        NavMenuItem(label: Constants.upcomingViewLabel),
        NavMenuItem(label: Constants.completedViewLabel)
    ]
    
    private let secondaryMenuItems = [
        NavMenuItem(label: Constants.tagsViewLabel)
    ]
    
    private let settingsMenuItems: [NavMenuItem] = [
        NavMenuItem(label: Constants.settingsViewLabel)
    ]
    
    private func getMenuItems() -> [NavMenuItem] {
        var menuItems: [NavMenuItem] = []
        for list in listsApi.lists {
            menuItems.append(NavMenuItem(label: list.listName, list: list))
        }
        
        return menuItems
    }
    
    func getAllMenuItems() -> [NavMenuItem] {
        return defaultMenuItems + secondaryMenuItems + getMenuItems() + settingsMenuItems
    }
    
    var defaultMenuView: some View {
        ForEach(defaultMenuItems) { menuItem in
            Button(menuItem.label) {
                path.append(menuItem.label)
            }.foregroundColor(Color(UIColor.label))
        }
    }
    
    var secondaryMenuView: some View {
        Section {
            ForEach(secondaryMenuItems) { menuItem in
                Button(menuItem.label) {
                    path.append(menuItem.label)
                }.foregroundColor(Color(UIColor.label))
            }
        }
    }
    
    var listsView: some View {
        Section(header: Text("Lists")) {
            ForEach(getMenuItems()) { menuItem in
                Button (menuItem.label) {
                    path.append(menuItem.label)
                }.foregroundColor(Color(UIColor.label))
                    .contextMenu(ContextMenu(menuItems: {
                        Button("Update List") {
                            Task {
                                listsApi.showListModal = true;
                                listsApi.listToEdit = menuItem.list;
                            }
                        }
                        Button("Delete List", role: .destructive) {
                            isPresentingDeleteDialog = true;
                            listIdToDelete = menuItem.list?.id;
                        }
                    }))
            }
            .onMove(perform: { source, newIndex in
                guard let sourceIndex = source.first else { return }
                let insertIndex = sourceIndex > newIndex ? newIndex : newIndex - 1
                let list = listsApi.lists.remove(at: sourceIndex)
                listsApi.lists.insert(list, at: insertIndex)
                Task {
                    await listsApi.reorderLists(lists: listsApi.lists)
                }
            })
        }
        
    }
    
    var body: some View {
        VStack {
            if (!loginSignUpApi.isLoggedIn) {
                LoginSignUp()
            } else {
                ZStack(alignment: .bottomTrailing) {
                    NavigationStack(path: $path) {
                        List {
                            defaultMenuView
                            secondaryMenuView
                            if listsApi.hasFetchedLists {
                                listsView
                            } else {
                                ProgressView()
                            }
                        }
                        .navigationTitle("Home")
                        .navigationDestination(for: String.self) { viewLabel in
                            let associatedNavMenuItem = getAllMenuItems().first(where: { $0.label == viewLabel })
                            if (associatedNavMenuItem != nil) {
                                SubViewRouter(navMenuItem: associatedNavMenuItem!).onAppear {
                                    currentNavMenuItem = associatedNavMenuItem!
                                }.onDisappear {
                                    currentNavMenuItem = nil
                                }
                            }
                        }.toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    path.append(Constants.settingsViewLabel)
                                }) {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.blue) // Customize color
                                }
                            }
                        }
                    }.onAppear {
                        Task {
                            await listsApi.fetchLists()
                            await tagApi.fetchTags()
                            await settingsApi.fetchSettings()
                        }
                    }.onChange(of: scenePhase) { oldPhase, newPhase in
                        if newPhase == .active {
                            Task {
                                await listsApi.fetchLists()
                                
                                if currentNavMenuItem?.label == Constants.todayViewLabel {
                                    await taskApi.fetchTodayTasks()
                                } else if currentNavMenuItem?.label == Constants.upcomingViewLabel {
                                    await taskApi.fetchUpcomingTasks()
                                } else if currentNavMenuItem?.label == Constants.completedViewLabel {
                                    await taskApi.fetchCompletedTasks()
                                } else if currentNavMenuItem?.label == Constants.tagsViewLabel {
                                    await tagApi.fetchTags()
                                } else if currentNavMenuItem?.label == Constants.standupViewLabel {
                                    await taskApi.fetchStandupTasks(
                                        isIgnoringWeekends: settingsApi.dailyReportIgnoreWeekends
                                    )
                                }
                            }
                        }
                    }
                    
                    if currentNavMenuItem?.label != "Completed" {
                        NewTaskFAB(currentNavMenuItem: currentNavMenuItem)
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $taskApi.showTaskModal, onDismiss: {
            taskApi.taskToEdit = nil
            taskApi.showTaskModal = false
        }) {
            CreateTaskModal(task: taskApi.taskToEdit, currentNavMenuItem: currentNavMenuItem)
        }
        .sheet(
            isPresented: $listsApi.showListModal,
            onDismiss: {
                listsApi.showListModal = false
            },
            content: {
                CreateListModal(listToEdit: listsApi.listToEdit)
            })
        .sheet(isPresented: $tagApi.showTagModal, onDismiss: {
            tagApi.showTagModal = false
        }) {
            TagModal(tag: tagApi.selectedTag)
        }
        .confirmationDialog(
            "This will delete the list and all tasks in it. Are you sure you want to proceed?",
            isPresented: $isPresentingDeleteDialog
        ) {
            Button("Delete list and all tasks", role: .destructive) {
                Task {
                    await listsApi.deleteList(listId: listIdToDelete!)
                }
            }.onDisappear {
                listIdToDelete = nil
            }
        }
        .alert(globalMessages.alertMessage, isPresented: $globalMessages.showAlert, actions: {
            Button("OK") { globalMessages.showAlert = false }
        })
    }
}
