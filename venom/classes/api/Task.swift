//
//  Task.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//

import Foundation

struct VenomTask: Decodable, Identifiable {
    let id: Int;
    let taskName: String;
    let dueDate: String?;
    let listViewOrder, timeViewOrder: Int?;
    let isCompleted: Bool;
    let list: VenomList?;
    let taskTag: [TaskTag]?;
    let tagIds: [Int]
}

struct TaskApi {
    @discardableResult
    static func createTask(taskName: String, dueDate: Date?, listId: Int, lists: Lists) async -> Bool {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd";
        let formattedDueDate = dueDate != nil ? dateFormatter.string(from: dueDate!) : "";
        
        do {
            let newTaskBody: [String: Any] = [
                "taskName": taskName,
                "dueDate": formattedDueDate,
                "listId": listId
            ];
            try await sendApiCall(url: Constants.tasksUrl!, requestMethod: "POST", requestBody: newTaskBody, verboseLogging: true)
            
            Task {
                await lists.fetchLists()
            }
            
            return true;
        } catch {
            print("Caught error when creating a task \(error)")
            return false;
        }
    }
}
