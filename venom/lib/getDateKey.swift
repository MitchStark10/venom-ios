//
//  getDateKey.swift
//  venom
//
//  Created by Mitch Stark on 7/4/24.
//

import Foundation

func getRelativeTimeSpanString(for date: Date?) -> String {
    if (date == nil) {
        return "No Due Date"
    }
    
    let relativeFormatter = RelativeDateTimeFormatter()
    relativeFormatter.unitsStyle = .full // or .short or .abbreviated depending on the desired format
    let now = Date()
    let relativeFormattedDueDate = relativeFormatter.localizedString(for: Calendar.current.startOfDay(for: date!), relativeTo: Calendar.current.startOfDay(for: now))
    
    if (relativeFormattedDueDate.lowercased() == "in 0 seconds") {
        return "Due Today"
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd"
    
    return "\(dateFormatter.string(for: date!)!) - Due \(relativeFormattedDueDate)"
}

func getDateKey(task: VenomTask) -> String {
    if (task.dueDate == nil) {
        return "No Due Date"
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    return getRelativeTimeSpanString(for: dateFormatter.date(from: task.dueDate!))
}
