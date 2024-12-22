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
}

class SettingsApi: ObservableObject {
    @Published var userEmail = "";
    @Published var autoDeleteTasksValue = "-1";
    
    public func fetchSettings() async {
        do {
            let settingsResponse = try await sendApiCall(url: Constants.settingsUrl!, requestMethod: "GET", verboseLogging: true)
            let settingsResponseData = try JSONDecoder().decode(SettingsResponse.self, from: settingsResponse)
            DispatchQueue.main.async {
                self.userEmail = settingsResponseData.email
                self.autoDeleteTasksValue = settingsResponseData.autoDeleteTasks
            }
        } catch {
            print("Caught error when updating a list \(error)")
        }
    }
    
    public func updateSettings(newValue: String) async {
        do {
            let settingsRequestBody = ["autoDeleteTasks": newValue];
            try await sendApiCall(url: Constants.settingsUrl!, requestMethod: "PUT", requestBody: settingsRequestBody)
        } catch {
            print("Caught error when updating settings \(error)")
        }
    }
}

