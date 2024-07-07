//
//  ContentView.swift
//  venom
//
//  Created by Mitch Stark on 3/17/24.
//

import SwiftUI

struct AppEntryView: View {
    @State private var hasSignedIn = initializeSignInStatus();
    @State private var isShowingNewTaskModal = false;
    @EnvironmentObject var lists: Lists
    @EnvironmentObject var taskApi: TaskApi
    private let defaultMenuItems = [NavMenuItem(label: "Today"), NavMenuItem(label: "Upcoming"), NavMenuItem(label: "Completed")];
    
    private func getMenuItems() -> [NavMenuItem] {
        var menuItems: [NavMenuItem] = []
        for list in lists.lists {
            menuItems.append(NavMenuItem(label: list.listName, list: list))
        }
        
        return menuItems
    }
    
    var body: some View {
        VStack {
            if (!hasSignedIn) {
                LoginSignUp(hasSignedIn: $hasSignedIn)
            } else {
                ZStack(alignment: .bottomTrailing) {
                    NavigationStack {
                        List {
                            ForEach(defaultMenuItems) { menuItem in
                                NavigationLink(destination: SubViewRouter(navMenuItem: menuItem)) {
                                    Text(menuItem.label)
                                }
                            }
                            
                            Section(header: Text("Lists")) {
                                ForEach(getMenuItems()) { menuItem in
                                    NavigationLink(destination: SubViewRouter(navMenuItem: menuItem)) {
                                        Text(menuItem.label)
                                    }
                                }
                            }
                        }
                        .navigationTitle("Home")
                        .navigationBarTitleDisplayMode(.inline)
                        
                    }.onAppear {
                        Task {
                            await lists.fetchLists()
                        }
                    }
                    
                    NewTaskFAB(isShowingNewTaskModal: $isShowingNewTaskModal)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height, alignment: .topLeading)
        .sheet(isPresented: $isShowingNewTaskModal) {
            CreateTaskModal(isShowingNewTaskModal: $isShowingNewTaskModal)
        }
    }
}
