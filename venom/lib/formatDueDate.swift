//
//  formatDueDate.swift
//  venom
//
//  Created by Mitch Stark on 7/4/24.
//

import Foundation

func formatDate(dateToFormat: Date?) -> String {
    let dateFormatter = DateFormatter();
    dateFormatter.dateFormat = "yyyy-MM-dd";
    return dateToFormat != nil ? dateFormatter.string(from: dateToFormat!) : "";
}
