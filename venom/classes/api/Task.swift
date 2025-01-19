//
//  Task.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//
import Foundation
import SwiftUI

class StandupResponse: Decodable, @unchecked Sendable {
    let today: [VenomTask]
    let yesterday: [VenomTask]
    let blocked: [VenomTask]
}

class VenomTask: Decodable, Identifiable, @unchecked Sendable {
    let id: Int
    var taskName: String
    var dueDate, dateCompleted: String?
    let listViewOrder, timeViewOrder: Int?
    var isCompleted: Bool
    let taskTag: [TaskTag]?
    let list: VenomList?
    var tagIds: [Int]
    var listId: Int?
    var customGroup: String?
    
    public func toJsonObject() -> [String: Any?] {
        return [
            "listId": self.listId,
            "taskName": self.taskName,
            "dueDate": self.dueDate ?? nil,
            "dateCompleted": self.dateCompleted ?? nil,
            "isCompleted": self.isCompleted,
            "tagIds": self.tagIds
        ]
    }
}

class TaskApi: ApiClient, ObservableObject, @unchecked Sendable {
    @Published var hasFetchedTodayTasks = false
    @Published var todayTasks: [VenomTask] = []
    
    @Published var hasFetchedUpcomingTasks = false
    @Published var upcomingTasks: [VenomTask] = []
    
    @Published var hasFetchedCompletedTasks = false
    @Published var completedTasks: [VenomTask] = []
	
	@Published var hasFetchedStandupTasks = false
	@Published var standupYesterdayTasks: [VenomTask] = []
    @Published var standupTodayTasks: [VenomTask] = []
    @Published var standupBlockedTasks: [VenomTask] = []
    @Published var standupTasks: [VenomTask] = []
    
    @Published var taskToEdit: VenomTask?
    @Published var showTaskModal: Bool = false
    
    @discardableResult
    func createTask(taskName: String, dueDate: Date?, listId: Int, listsApi: ListsApi, tagIds: [Int]) async -> Bool {
        do {
            let newTaskBody: [String: Any] = [
                "taskName": taskName,
                "dueDate": formatDate(dateToFormat: dueDate),
                "listId": listId,
                "tagIds": tagIds
            ]
            try await sendApiCall(url: Constants.tasksUrl!, requestMethod: "POST", requestBody: newTaskBody)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                Task {
                    await listsApi.fetchLists()
                }
            }
            
            return true
        } catch {
            print("Caught error when creating a task \(error)")
            return false
        }
    }
    
    @discardableResult
    func updateTask(task: VenomTask, listsApi: ListsApi) async -> Bool {
        do {
            try await sendApiCall(
                url: Constants.getTaskUrlWithId(id: task.id),
                requestMethod: "PUT",
                requestBody: task.toJsonObject()
            )
            Task {
                await listsApi.fetchLists()
            }
            return true
        } catch {
            print("Caught an error updating the task: \(error)")
            return false
        }
    }
    
    func fetchTodayTasks() async {
        do {
            let data = try await sendApiCall(url: Constants.getTodayTasksUrl(), requestMethod: "GET")
            let fetchedTasks = try JSONDecoder().decode([VenomTask].self, from: data)
            
            DispatchQueue.main.async {
                self.todayTasks = fetchedTasks
                self.objectWillChange.send()
                self.hasFetchedTodayTasks = true
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
                self.upcomingTasks = fetchedTasks
                self.objectWillChange.send()
                self.hasFetchedUpcomingTasks = true
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
                self.completedTasks = fetchedTasks
                self.objectWillChange.send()
                self.hasFetchedCompletedTasks = true
            }
        } catch {
            print("Caught an error retrieving completed tasks: \(error)")
        }
    }
    
    func deleteCompletedTasks() async {
        do {
            try await sendApiCall(url: Constants.completedTasksUrl!, requestMethod: "DELETE")
            await fetchCompletedTasks()
        } catch {
            print("Caught an error deleting completed tasks: \(error)")
        }
    }
	
    func fetchStandupTasks(isIgnoringWeekends: Bool) async {
        do {
            let data = try await sendApiCall(url: Constants.getStandupTasksUrl(), requestMethod: "GET")
            let fetchedTasks = try JSONDecoder().decode(StandupResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.standupTodayTasks = fetchedTasks.today.map { task in
                    task.customGroup = "Today"
                    return task
                }
                self.standupYesterdayTasks = fetchedTasks.yesterday.map { task in
                    // If today is Monday and we're ignoring weekends, then the group label
                    // should instead be "Friday
                    if isTodayMonday() && isIgnoringWeekends {
                        task.customGroup = "Friday"
                    } else {
                        task.customGroup = "Yesterday"
                    }
                    return task
                }
                self.standupBlockedTasks = fetchedTasks.blocked.map { task in
                    task.customGroup = "Blocked"
                    return task
                }
                self.standupTasks =  self.standupYesterdayTasks + self.standupTodayTasks + self.standupBlockedTasks
                
                self.objectWillChange.send()
                self.hasFetchedStandupTasks = true
            }
        } catch {
            print("Caught an error retrieving standup tasks: \(error)")
        }
	}
    
    func reorder(taskList: [VenomTask], listsApi: ListsApi) async {
        do {
            let tasksToUpdate = taskList.enumerated().map { (index, task) in
                return [
                    "id": task.id,
                    "fieldToUpdate": "listViewOrder",
                    "newOrder": index,
                    "newDueDate": task.dueDate ?? ""
                ]
            }
            
            let requestBody = [
                "tasksToUpdate": tasksToUpdate
            ]
            
            try await sendApiCall(url: Constants.reorderTaskUrl!, requestMethod: "PUT", requestBody: requestBody)
            
            Task {
                await listsApi.fetchLists()
            }
        } catch {
            print("Caught an error while reordering task: \(error.localizedDescription)")
        }
    }
}
