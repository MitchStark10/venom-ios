//
//  ContentView.swift
//  venom
//
//  Created by Mitch Stark on 3/17/24.
//

import SwiftUI

struct AppEntryView: View {
    @State private var hasSignedIn = initializeSignInStatus();
    
    var body: some View {
        VStack {
            if (!hasSignedIn) {
                LoginSignUp(hasSignedIn: $hasSignedIn)
            } else {
                let coreMenuItems = ["Today", "Upcoming", "Completed"];
                NavigationStack {
                    ZStack(alignment: .bottomTrailing) {
                        List(coreMenuItems, id: \.self) { listItem in
                            NavigationLink(destination: Text("\(listItem) View")) {
                                Text(listItem)
                            }
                        }
                        .navigationTitle("Home")
                        
                        NewTaskFAB()
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height, alignment: .topLeading)
    }
}

#Preview {
    AppEntryView()
}
