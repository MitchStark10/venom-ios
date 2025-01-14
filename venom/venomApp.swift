//
//  venomApp.swift
//  venom
//
//  Created by Mitch Stark on 3/17/24.
//

import SwiftUI

@main
struct VenomApp: App {
    @State var globalMessages: GlobalMessages
    @State var lists: Lists
    @State var taskApi: TaskApi
    @State var tagApi: TagApi
    @State var loginSignUpApi: LoginSignUpApi
    @State var settingsApi: SettingsApi
    
    @State var hasInitialized: Bool = false
    private var initialGlobalMessages: GlobalMessages
    
    init() {
        self.initialGlobalMessages = GlobalMessages()
        _globalMessages = State(initialValue: initialGlobalMessages)
        _lists = State(initialValue: Lists(lists: [], globalMessages: initialGlobalMessages))
        self.taskApi = TaskApi(initialGlobalMessages)
        self.tagApi = TagApi(initialGlobalMessages)
        self.loginSignUpApi = LoginSignUpApi(initialGlobalMessages)
        self.settingsApi = SettingsApi(initialGlobalMessages)
    }
    
    var body: some Scene {
        WindowGroup {
            AppEntryView()
                .environmentObject(lists)
                .environmentObject(taskApi)
                .environmentObject(tagApi)
                .environmentObject(loginSignUpApi)
                .environmentObject(settingsApi)
                .environmentObject(globalMessages)    
        }
    }
}
