//
//  getDateKey.swift
//  venom
//
//  Created by Mitch Stark on 7/4/24.
//

import Foundation

func isValidDateString(_ dateString: String) -> Bool {
    // Create a date formatter
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    // Check if the string can be converted to a date
    if let _ = dateFormatter.date(from: dateString) {
        return true
    } else {
        return false
    }
}

func getDateGroupHeader(for dateString: String) -> String {
    if (dateString == "No Due Date") {
        return dateString;
    }
    
    let dateFormatParser = DateFormatter()
    dateFormatParser.dateFormat = "yyyy-MM-dd"
    let date = dateFormatParser.date(from: dateString)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd"
    
    if (date == nil) {
        return dateString
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
    
    return task.dueDate!
}
