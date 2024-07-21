//
//  Constants.swift
//  venom
//
//  Created by Mitch Stark on 3/20/24.
//

import Foundation

struct Constants {
    static let baseApiUrl = "https://venom-backend-pjv4.onrender.com"
    static let accessTokenKeychainKey = "accessToken"
    static let loginUrl = URL(string: baseApiUrl + "/users/login")
    static let listsUrl = URL(string: baseApiUrl + "/lists")
    static let tasksUrl = URL(string: baseApiUrl + "/tasks")
    static let completedTasksUrl = URL(string: baseApiUrl + "/tasks/completed")

    static func getTodayTasksUrl() -> URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return URL(string: "\(baseApiUrl)/tasks/today?today=\(dateFormatter.string(from: Date()))")!
    }
    
    static func getUpcomingTasksUrl() -> URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return URL(string: "\(baseApiUrl)/tasks/upcoming?today=\(dateFormatter.string(from: Date()))")!
    }

    static func getTaskUrlWithId(id: Int) -> URL {
        return URL(string: baseApiUrl + "/tasks/\(id)")!
    }
    
    static func getListUrlWithId(id: Int) -> URL {
        return URL(string: baseApiUrl + "/lists/\(id)")!
    }
}
