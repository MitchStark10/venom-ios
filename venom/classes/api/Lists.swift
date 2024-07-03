//
//  Lists.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//
import Foundation
import SwiftUI

struct VenomList: Decodable {
    let id, order: Int;
    let listName: String;
    let tasks: [VenomTask];
}

class Lists: ObservableObject {
    @Published var lists: [VenomList] = []
    
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
}