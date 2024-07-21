//
//  NewTaskFAB.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//
import SwiftUI

struct NewTaskFAB: View {
    @EnvironmentObject var listApi: Lists;
    @EnvironmentObject var taskApi: TaskApi;
    
    @State private var showingActionSheet = false;
    
    var body: some View {
        Button {
            showingActionSheet = true;
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
                    listApi.showNewListModal = true;
                },
                .cancel()
            ])
        }
        .padding(.trailing, 20)
        
    }
}
