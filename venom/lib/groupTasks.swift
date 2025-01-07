//
//  groupTasks.swift
//  venom
//
//  Created by Mitch Stark on 7/4/24.
//

import Foundation

func taskSorter(taskA: VenomTask?, taskB: VenomTask?) -> Bool {
    let listAViewOrder = taskA?.listViewOrder ?? Int.max
    let listBViewOrder = taskB?.listViewOrder ?? Int.max
    
    if listAViewOrder > listBViewOrder {
        return false;
    } else if listAViewOrder < listBViewOrder {
        return true;
    } else {
        return true;
    }
}

enum GroupByOptions: String {
    case date = "date"
    case list = "list"
    case customGroup = "customGroup"
}

func groupTasks(tasks: [VenomTask], groupBy: GroupByOptions) -> Dictionary<String, [VenomTask]> {
    var groupedTasks: Dictionary<String, [VenomTask]> = Dictionary()
    
    if (groupBy == GroupByOptions.date) {
        let sortedTasks = tasks.sorted(by: taskSorter);
        
        for task in sortedTasks {
            let taskDateKey = getDateKey(task: task)
            
            if (groupedTasks[taskDateKey] == nil) {
                groupedTasks[taskDateKey] = [];
            }
            
            groupedTasks[taskDateKey]?.append(task)
        }
    } else if (groupBy == GroupByOptions.customGroup) {
        for task in tasks {
            let groupKey = task.customGroup ?? "Unknown Group";
            if (groupedTasks[groupKey] == nil) {
                groupedTasks[groupKey] = []
            }
            
            groupedTasks[groupKey]?.append(task)
        }
    } else {
        for task in tasks {
            let groupKey = task.list?.listName ?? "Unknown List";
            if (groupedTasks[groupKey] == nil) {
                groupedTasks[groupKey] = []
            }
            
            groupedTasks[groupKey]?.append(task)
        }
    }
    
    return groupedTasks
}
