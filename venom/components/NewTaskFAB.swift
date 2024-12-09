//
//  NewTaskFAB.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//
import SwiftUI

let autoCreateTaskLabels = [Constants.todayViewLabel, Constants.upcomingViewLabel, Constants.completedViewLabel]

struct NewTaskFAB: View {
    @EnvironmentObject var listApi: Lists;
    @EnvironmentObject var taskApi: TaskApi;
    @EnvironmentObject var tagApi: TagApi;
    
    @State private var showingActionSheet = false;
    
    let currentNavMenuItem: NavMenuItem?
    
    init (currentNavMenuItem: NavMenuItem?) {
        self.currentNavMenuItem = currentNavMenuItem
    }
    
    var body: some View {
        Button {
            let currentLabel = currentNavMenuItem?.label ?? "";
            if (listApi.lists.isEmpty) {
                listApi.showListModal = true;
            } else if (autoCreateTaskLabels.contains(currentLabel)) {
                taskApi.showTaskModal = true
            } else if (currentLabel == Constants.tagsViewLabel) {
                tagApi.showTagModal = true
            } else if (currentLabel != "") {
                taskApi.showTaskModal = true
            } else {
                showingActionSheet = true;
            }
        } label: {
            Image(systemName: "plus")
                .font(.title.weight(.semibold))
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 4, x: 0, y: 4)
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text("Menu"), buttons: [
                .default(Text("Create Task")) {
                    taskApi.showTaskModal = true;
                },
                .default(Text("Create List")) {
                    listApi.showListModal = true;
                },
                .default(Text("Create Tag")) {
                    tagApi.showTagModal = true;
                },
                .cancel()
            ])
        }
        .padding(.trailing, 20)
        
    }
}
