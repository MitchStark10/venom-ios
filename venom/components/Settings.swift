//
//  Settings.swift
//  venom
//
//  Created by Mitch Stark on 12/22/24.
//
import SwiftUI

struct PickerOption {
    let value: String
    let label: String
}

struct Settings: View {
    @EnvironmentObject var lists: Lists
    @EnvironmentObject var loginSignUpApi: LoginSignUpApi
    @EnvironmentObject var settingsApi: SettingsApi
    
    @Environment(\.colorScheme) var colorScheme // Detect the current color scheme
    
    @State var isPresentingDeleteDialog = false
    @State var isLoading = true
    @State var dailyReportListIds: Set<Int> = []
    
    private let autoDeleteTaskOptions: [PickerOption] = [
        PickerOption(value: "-1", label: "Never"),
        PickerOption(value: "7", label: "1 Week After Task Completion"),
        PickerOption(value: "14", label: "2 Weeks After Task Completion"),
        PickerOption(value: "30", label: "1 Month After Task Completion")
    ]
    
    private func handleSettingsChange() async {
        await settingsApi.updateSettings(
            newAutoDeleteTasksValue: settingsApi.autoDeleteTasksValue,
            newDailyReportIgnoreWeeekndsValue: settingsApi.dailyReportIgnoreWeekends
        )
    }
    
    private var dailyReportSettings: some View {
        Section(header: Text("Daily Report Settings").font(.subheadline)) {
            Picker("Auto-Delete Tasks", selection: $settingsApi.autoDeleteTasksValue) {
                ForEach(autoDeleteTaskOptions, id: \.value) { option in
                    Text(option.label).tag(option.value)
                }
            }
            MultiSelect(title: "Daily Report Lists", items: lists.lists.map { list in
                return MultiSelectData(value: list.id, label: list.listName)
            }, selectedItems: $dailyReportListIds)
            
            Toggle("Use work week calendar for daily report", isOn: $settingsApi.dailyReportIgnoreWeekends)
        }
    }
    
    private var accountSettings: some View {
        Section(header: Text("Account Settings").font(.subheadline)) {
            Text("Signed in as: \(settingsApi.userEmail)")
            HStack {
                Button("Logout") {
                    let signoutResponse = loginSignUpApi.signOut()
                    if signoutResponse {
                        loginSignUpApi.isLoggedIn = false
                    }
                }.buttonStyle(BorderedProminentButtonStyle()).padding(0)
                
                Button("Delete Account", role: .destructive) {
                    isPresentingDeleteDialog = true
                }.buttonStyle(BorderedButtonStyle()).padding(0)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if !isLoading {
                Form {
                    dailyReportSettings
                    accountSettings
                    Section(header: Text("Desktop Access").font(.subheadline)) {
                        Text("You can also use Venom Tasks on the web at: https://venomtasks.com")
                    }
                }
                .onChange(of: dailyReportListIds) {
                    for list in lists.lists {
                        let isListNewlyAddedToStandup = !list.isStandupList && dailyReportListIds.contains(list.id)
                        let isListRemovedFromStandup = list.isStandupList && !dailyReportListIds.contains(list.id)
                        if isListNewlyAddedToStandup || isListRemovedFromStandup {
                            list.isStandupList.toggle()
                            Task {
                                await lists.updateList(list: list)
                            }
                        }
                    }
                }.onChange(of: settingsApi.autoDeleteTasksValue) {
                    Task {
                        await handleSettingsChange()
                    }
                }.onChange(of: settingsApi.dailyReportIgnoreWeekends) {
                    Task {
                        await handleSettingsChange()
                    }
                }
            }
        }
        .onAppear {
            dailyReportListIds = Set(lists.lists.filter { $0.isStandupList }.map { $0.id })
            Task {
                await settingsApi.fetchSettings()
                isLoading = false
            }
        }
        .confirmationDialog(
            "Your entire account will be deleted. "
            + "This includes all lists, tags, and tasks. Are you sure you wish to proceed?",
            isPresented: $isPresentingDeleteDialog,
            titleVisibility: .visible
        ) {
            Button("Delete account", role: .destructive) {
                Task {
                    await settingsApi.deleteAccount()
                    loginSignUpApi.signOut()
                    loginSignUpApi.isLoggedIn = false
                }
            }
        }.navigationTitle("Settings")
    }
}
