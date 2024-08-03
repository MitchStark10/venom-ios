//
//  TaskTag.swift
//  venom
//
//  Created by Mitch Stark on 7/2/24.
//

import Foundation

struct TaskTag: Decodable, Identifiable {
    var id: String { "\(taskId)\(tagId)" }
    let taskId: Int;
    let tagId: Int;
    let tag: Tag;
}
