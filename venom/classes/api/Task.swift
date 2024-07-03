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
