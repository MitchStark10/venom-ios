//
//  TaskList.swift
//  venom
//
//  Created by Mitch Stark on 7/2/24.
//

import Foundation
import SwiftUI

struct TaskList: View {
    var taskItems: [VenomTask]
    var navTitle: String
    
    var body: some View {
        List {
            ForEach(taskItems) { task in
                HStack {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .onTapGesture {
                            print("TBD!")
                        }
                    Text(task.taskName)
                        .strikethrough(task.isCompleted, color: .black)
                }
            }
        }.navigationTitle(navTitle)
    }
}

struct Preview: PreviewProvider {
    static var previews: some View {
        NavigationLink(destination: SubViewRouter(navMenuItem: NavMenuItem(label: "Test", list: VenomList(id: 1, order: 1, listName: "test", tasks: [])))) {
            Text("test")
        }
    }
}
