//
//  Lists.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//
import Foundation
import SwiftUI

class VenomList: Decodable, Hashable, @unchecked Sendable {
    let id, order: Int
    var listName: String
    var isStandupList: Bool
    var tasks: [VenomTask]? = []
    
    static func == (lhs: VenomList, rhs: VenomList) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var identifier: String {
        return String(self.id)
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
}

class Lists: ApiClient, ObservableObject, @unchecked Sendable {
    @Published var hasFetchedLists = false
    @Published var lists: [VenomList] = []
    
    @Published var showListModal = false
    @Published var listToEdit: VenomList?
    
    init(lists: [VenomList], globalMessages: GlobalMessages) {
        self.lists = lists
        super.init(globalMessages)
    }
    
    public func fetchLists() async {
        do {
            let listsResponse = try await sendApiCall(
                url: Constants.listsUrl!,
                requestMethod: "GET",
                fallbackErrorMesssage: "Failed to retrieve lists. Please try again later."
            )
            let newLists = try JSONDecoder().decode([VenomList].self, from: listsResponse)
            DispatchQueue.main.async {
                self.lists = newLists
                self.hasFetchedLists = true
            }
        } catch {
            venomLogger.error("Caught error when fetching lists \(error)")
        }
    }
    
    public func createList(listName: String) async {
        do {
            let requestBody = ["listName": listName]
            try await sendApiCall(url: Constants.listsUrl!, requestMethod: "POST", requestBody: requestBody)
            await fetchLists()
        } catch {
            venomLogger.error("Caught error when creating a new list \(error)")
        }
    }
    
    public func updateList(list: VenomList) async {
        do {
            let requestBody: [String: Any] = [
                "listName": list.listName,
                "isStandupList": list.isStandupList
            ]
            try await sendApiCall(
                url: Constants.getListUrlWithId(id: list.id),
                requestMethod: "PUT",
                requestBody: requestBody
            )
            await fetchLists()
        } catch {
            venomLogger.error("Caught error when updating a list \(error)")
        }
    }
    
    public func deleteList(listId: Int) async {
        do {
            try await sendApiCall(url: Constants.getListUrlWithId(id: listId), requestMethod: "DELETE")
            await fetchLists()
        } catch {
            venomLogger.error("Caught error when deleting a list \(error)")
        }
    }
}
