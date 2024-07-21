//
//  Lists.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//
import Foundation
import SwiftUI

struct VenomList: Decodable, Hashable {
    let id, order: Int;
    let listName: String;
    var tasks: [VenomTask]? = [];
    
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

class Lists: ObservableObject {
    @Published var lists: [VenomList] = []
    @Published var showNewListModal = false;
    
    init(lists: [VenomList]) {
        self.lists = lists
    }
    
    public func fetchLists() async {
        do {
            let listsResponse = try await sendApiCall(url: Constants.listsUrl!, requestMethod: "GET")
            let newLists = try JSONDecoder().decode([VenomList].self, from: listsResponse)
            DispatchQueue.main.async {
                self.lists = newLists
            }
        } catch {
            print("Caught error when fetching lists \(error)")
            // TODO: Toast message in the UI?
        }
    }
    
    public func createList(listName: String) async {
        do {
            let requestBody = ["listName": listName]
            let createListResponse = try await sendApiCall(url: Constants.listsUrl!, requestMethod: "POST", requestBody: requestBody)
            await fetchLists()
        } catch {
            print("Caught error when creating a new list \(error)")
        }
    }
    
    public func deleteList(listId: Int) async {
        do {
            try await sendApiCall(url: Constants.getListUrlWithId(id: listId), requestMethod: "DELETE")
            await fetchLists()
        } catch {
            print("Caught error when deleting a list \(error)")
        }
    }
}
