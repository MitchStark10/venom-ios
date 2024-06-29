//
//  Lists.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//
import Foundation
import SwiftUI


class Lists: ObservableObject {
    struct VenomList {
        let id, order: Int;
        let listName: String;
        let tasks: [VenomTask];
    }
    
    @Published var lists: [VenomList] = []
    
    init(lists: [VenomList]) {
        self.lists = lists
    }
    
    public func fetchLists() {
        self.lists.append(VenomList(id: 1, order: 1, listName: "Test", tasks: []))
    }
}
