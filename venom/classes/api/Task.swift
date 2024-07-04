//
//  Task.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//

import Foundation

class VenomTask: Decodable, Identifiable {
    let id: Int;
    let taskName: String;
    let dueDate: String?;
    let listViewOrder, timeViewOrder: Int?;
    var isCompleted: Bool;
    let list: VenomList?;
    let taskTag: [TaskTag]?;
    let tagIds: [Int]
    
    public func toJsonObject() -> [String: Any] {
        return [
            "taskName": self.taskName,
            "dueDate": self.dueDate ?? "",
            "isCompleted": self.isCompleted,
            "tagIds": self.tagIds
        ]
    }
}

struct TaskApi {
    @discardableResult
    static func createTask(taskName: String, dueDate: Date?, listId: Int, lists: Lists) async -> Bool {
        do {
            let newTaskBody: [String: Any] = [
                "taskName": taskName,
                "dueDate": formatDate(dateToFormat: dueDate),
                "listId": listId
            ];
            try await sendApiCall(url: Constants.tasksUrl!, requestMethod: "POST", requestBody: newTaskBody)
            
            Task {
                await lists.fetchLists()
            }
            
            return true;
        } catch {
            print("Caught error when creating a task \(error)")
            return false;
        }
    }
    
    @discardableResult
    static func updateTask(task: VenomTask, lists: Lists) async -> Bool {
        do {
            try await sendApiCall(url: Constants.getTaskUrlWithId(id: task.id), requestMethod: "PUT", requestBody: task.toJsonObject())
            Task {
                await lists.fetchLists()
            }
            return true;
        } catch {
            print("Caught an error updating the task: \(error)")
            return false;
        }
    }
}
