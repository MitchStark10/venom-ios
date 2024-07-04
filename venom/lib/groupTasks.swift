//
//  groupTasks.swift
//  venom
//
//  Created by Mitch Stark on 7/4/24.
//

import Foundation

func taskSorter(a: VenomTask?, b: VenomTask?) -> Bool {
    let listAViewOrder = a?.listViewOrder ?? Int.max
    let listBViewOrder = b?.listViewOrder ?? Int.max
    
    if listAViewOrder > listBViewOrder {
        return true;
    } else if listAViewOrder < listBViewOrder {
        return false;
    } else {
        return true;
    }
}


func groupTasks(tasks: [VenomTask]) -> Dictionary<String, [VenomTask]> {
    var groupedTasks: Dictionary<String, [VenomTask]> = Dictionary()
    let sortedTasks = tasks.sorted(by: taskSorter);
    
    for task in sortedTasks {
        let taskDateKey = getDateKey(task: task)
        
        if (groupedTasks[taskDateKey] == nil) {
            groupedTasks[taskDateKey] = [];
        }
        
        groupedTasks[taskDateKey]?.append(task)
    }
    
    return groupedTasks
}
