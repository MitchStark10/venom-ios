//
//  venomApp.swift
//  venom
//
//  Created by Mitch Stark on 3/17/24.
//

import SwiftUI

@main
struct VenomApp: App {
    @State var lists = Lists(lists: [])
    @State var taskApi = TaskApi()
    @State var tagApi = TagApi()
    @State var loginSignUpApi = LoginSignUpApi()
    @State var settingsApi = SettingsApi()
    
    var body: some Scene {
        WindowGroup {
            AppEntryView()
                .environmentObject(lists)
                .environmentObject(taskApi)
                .environmentObject(tagApi)
                .environmentObject(loginSignUpApi)
                .environmentObject(settingsApi)
        }
    }
}
