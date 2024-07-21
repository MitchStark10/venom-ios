//
//  Task.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//
import Foundation
import SwiftUI

class VenomTask: Decodable, Identifiable {
    let id: Int;
    var taskName: String;
    var dueDate: String?;
    let listViewOrder, timeViewOrder: Int?;
    var isCompleted: Bool;
    let taskTag: [TaskTag]?;
    let list: VenomList?;
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

class TaskApi: ObservableObject {
    @Published var todayTasks: [VenomTask] = [];
    @Published var upcomingTasks: [VenomTask] = [];
    @Published var completedTasks: [VenomTask] = [];
    @Published var taskToEdit: VenomTask?;
    @Published var showTaskModal: Bool = false;
    
    @discardableResult
    func createTask(taskName: String, dueDate: Date?, listId: Int, lists: Lists) async -> Bool {
        do {
            let newTaskBody: [String: Any] = [
                "taskName": taskName,
                "dueDate": formatDate(dateToFormat: dueDate),
                "listId": listId
            ];
            try await sendApiCall(url: Constants.tasksUrl!, requestMethod: "POST", requestBody: newTaskBody)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                Task {
                    await lists.fetchLists()
                }
            }
            
            return true;
        } catch {
            print("Caught error when creating a task \(error)")
            return false;
        }
    }
    
    @discardableResult
    func updateTask(task: VenomTask, lists: Lists) async -> Bool {
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
    
    func fetchTodayTasks() async {
        do {
            let data = try await sendApiCall(url: Constants.getTodayTasksUrl(), requestMethod: "GET")
            let fetchedTasks = try JSONDecoder().decode([VenomTask].self, from: data)
            
            DispatchQueue.main.async {
                self.todayTasks = fetchedTasks;
                self.objectWillChange.send()
            }
        } catch {
            print("Caught an error retrieving today's tasks: \(error)")
        }
    }
    
    func fetchUpcomingTasks() async {
        do {
            let data = try await sendApiCall(url: Constants.getUpcomingTasksUrl(), requestMethod: "GET")
            let fetchedTasks = try JSONDecoder().decode([VenomTask].self, from: data)
            
            DispatchQueue.main.async {
                self.upcomingTasks = fetchedTasks;
                self.objectWillChange.send()
            }
        } catch {
            print("Caught an error retrieving today's tasks: \(error)")
        }
    }
    
    func fetchCompletedTasks() async {
        do {
            let data = try await sendApiCall(url: Constants.completedTasksUrl!, requestMethod: "GET")
            let fetchedTasks = try JSONDecoder().decode([VenomTask].self, from: data)
            
            DispatchQueue.main.async {
                self.completedTasks = fetchedTasks;
                self.objectWillChange.send()
            }
        } catch {
            print("Caught an error retrieving today's tasks: \(error)")
        }
    }
}
