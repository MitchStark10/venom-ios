//
//  Constants.swift
//  venom
//
//  Created by Mitch Stark on 3/20/24.
//

import Foundation

struct Constants {
    static let todayViewLabel = "Today"
    static let upcomingViewLabel = "Upcoming"
	static let standupViewLabel = "Daily Report"
    static let completedViewLabel = "Completed"
    static let tagsViewLabel = "Tags"
    static let settingsViewLabel = "Settings"
    
#if DEBUG
    static var baseApiUrl = "https://venom-backend-sand.onrender.com"
#else
    static let baseApiUrl = "https://venom-backend-pjv4.onrender.com"
#endif
    
    static let accessTokenKeychainKey = "accessToken"
    static let loginUrl = URL(string: baseApiUrl + "/users/login")
    static let signUpUrl = URL(string: baseApiUrl + "/users/createUser")
    static let listsUrl = URL(string: baseApiUrl + "/lists")
    static let reorderListsUrl = URL(string: baseApiUrl + "/lists/reorder")
    static let tasksUrl = URL(string: baseApiUrl + "/tasks")
    static let tagsUrl = URL(string: baseApiUrl + "/tags")
    static let completedTasksUrl = URL(string: baseApiUrl + "/tasks/completed")
    static let reorderTaskUrl = URL(string: baseApiUrl + "/tasks/reorder")
    static let settingsUrl = URL(string: baseApiUrl + "/settings")
    static let accountDeletionUrl = URL(string: baseApiUrl + "/settings/full-account")
    
    static let colorOptions = ["blue", "green", "orange", "red"]

    static func getTodayTasksUrl() -> URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return URL(string: "\(baseApiUrl)/tasks/today?today=\(dateFormatter.string(from: Date()))")!
    }
	
	static func getStandupTasksUrl() -> URL {
		let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return URL(string: "\(baseApiUrl)/tasks/standup?today=\(dateFormatter.string(from: Date()))")!
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
    
    static func getTagUrlWithId(id: Int) -> URL {
        return URL(string: baseApiUrl + "/tags/\(id)")!
    }
}
