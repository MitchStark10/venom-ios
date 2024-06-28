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
            Text("Venom").multilineTextAlignment(.center).frame(width: UIScreen.main.bounds.size.width).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(.bold)
            
            if (!hasSignedIn) {
                LoginSignUp(hasSignedIn: $hasSignedIn)
            } else {
                Text("TODO: Signed-In View")                
            }
            
            // TODO: Fetch the lists from the API
        }
        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 100, alignment: .topLeading)
    }
}

#Preview {
    AppEntryView()
}
