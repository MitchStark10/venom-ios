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
    
    private func getMenuItems() -> [NavMenuItem] {
        var menuItems = [NavMenuItem(label: "Today"), NavMenuItem(label: "Upcoming"), NavMenuItem(label: "Completed")];
        
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
                NavigationStack {
                    ZStack(alignment: .bottomTrailing) {
                        List(getMenuItems(), id: \.self) { listItem in
                            NavigationLink(destination: SubViewRouter(navMenuItem: listItem)) {
                                Text(listItem.label)
                            }
                        }
                        .navigationTitle("Home")
                        .navigationBarTitleDisplayMode(.inline)
                        
                        NewTaskFAB()
                    }
                }.onAppear {
                    Task {
                        await lists.fetchLists()
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height, alignment: .topLeading)
    }
}
