//
//  SettingsApi.swift
//  venom
//
//  Created by Mitch Stark on 12/22/24.
//

//
//  LoginSignUpApi.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//

import Foundation

struct SettingsResponse: Decodable {
    let email: String
    let autoDeleteTasks: String
    let dailyReportIgnoreWeekends: Bool
}

class SettingsApi: ApiClient, ObservableObject, @unchecked Sendable {
    @Published var userEmail = "";
    @Published var autoDeleteTasksValue = "-1";
    @Published var dailyReportIgnoreWeekends = false;
    
    public func fetchSettings() async {
        do {
            let settingsResponse = try await sendApiCall(url: Constants.settingsUrl!, requestMethod: "GET")
            let settingsResponseData = try JSONDecoder().decode(SettingsResponse.self, from: settingsResponse)
            DispatchQueue.main.async {
                self.userEmail = settingsResponseData.email
                self.autoDeleteTasksValue = settingsResponseData.autoDeleteTasks
                self.dailyReportIgnoreWeekends = settingsResponseData.dailyReportIgnoreWeekends
            }
        } catch {
            print("Caught error when updating a list \(error)")
        }
    }
    
    public func updateSettings(newAutoDeleteTasksValue: String, newDailyReportIgnoreWeeekndsValue: Bool) async {
        do {
            let settingsRequestBody: [String: Any] = [
                "autoDeleteTasks": newAutoDeleteTasksValue,
                "dailyReportIgnoreWeekends": newDailyReportIgnoreWeeekndsValue
            ];
            try await sendApiCall(url: Constants.settingsUrl!, requestMethod: "PUT", requestBody: settingsRequestBody)
        } catch {
            print("Caught error when updating settings \(error)")
        }
    }
    
    public func deleteAccount() async {
        do {
            try await sendApiCall(url: Constants.accountDeletionUrl!, requestMethod: "DELETE")
        } catch {
            print("Caught error when deleting account \(error)")
        }
    }
}

