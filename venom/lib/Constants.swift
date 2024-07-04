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
    
    static func getTaskUrlWithId(id: Int) -> URL {
        return URL(string: baseApiUrl + "/tasks/\(id)")!
    }
}
