//
//  isTodayMonday.swift
//  venom
//
//  Created by Mitch Stark on 1/5/25.
//

import Foundation

func isTodayMonday() -> Bool {
    let today = Date()
    let calendar = Calendar.current

    // Get the day of the week as an integer (1 = Sunday, 2 = Monday, etc.)
    let weekday = calendar.component(.weekday, from: today)

    // Check if it's Monday
    return weekday == 2
}
