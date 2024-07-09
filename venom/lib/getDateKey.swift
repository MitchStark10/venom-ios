//
//  getDateKey.swift
//  venom
//
//  Created by Mitch Stark on 7/4/24.
//

import Foundation

func getRelativeTimeSpanString(for date: Date?) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd"
    
    if (date == nil) {
        return "No Due Date"
    }
    
    let relativeFormatter = RelativeDateTimeFormatter()
    relativeFormatter.unitsStyle = .full // or .short or .abbreviated depending on the desired format
    let now = Date()
    let relativeFormattedDueDate = relativeFormatter.localizedString(for: Calendar.current.startOfDay(for: date!), relativeTo: Calendar.current.startOfDay(for: now))
    
    let prefix = "\(dateFormatter.string(for: date!)!) -"
    
    if (relativeFormattedDueDate.lowercased() == "in 0 seconds") {
        return "\(prefix) Due Today"
    }
    
    return "\(prefix) Due \(relativeFormattedDueDate)"
}

func getDateKey(task: VenomTask) -> String {
    if (task.dueDate == nil) {
        return "No Due Date"
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    return getRelativeTimeSpanString(for: dateFormatter.date(from: task.dueDate!))
}
