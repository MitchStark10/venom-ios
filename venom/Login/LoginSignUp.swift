//
//  LoginSignUp.swift
//  venom
//
//  Created by Mitch Stark on 3/19/24.
//
import SwiftUI

struct LoginSignUp: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isSigningUp: Bool = false
    @State private var apiRequestStatus: APIRequestStatus = APIRequestStatus.initial
    @State private var customStatusText = ""
    
    @EnvironmentObject var loginSignUpApi: LoginSignUpApi
    
    private func signIn() async -> Void {
        loginSignUpApi.errorMessage = ""
        if (isSigningUp && password != confirmPassword) {
            customStatusText = "Passwords do not match"
            return
        }
        
        customStatusText = ""
        
        do {
            apiRequestStatus = APIRequestStatus.processing
            let didLoginSucceed = isSigningUp ?
            try await loginSignUpApi.signUp(email: email, password: password)
            : try await loginSignUpApi.signIn(email: email, password: password)
            
            if (didLoginSucceed) {
                apiRequestStatus = APIRequestStatus.success
                loginSignUpApi.isLoggedIn = true;
            } else {
                apiRequestStatus = APIRequestStatus.failure
            }
        } catch _ {
            apiRequestStatus = APIRequestStatus.failure
        }
    }
    
    private func getStatusText () -> String {
        if (loginSignUpApi.errorMessage != "") {
            return loginSignUpApi.errorMessage
        } else if (customStatusText != "") {
            return customStatusText
        }
        
        switch apiRequestStatus {
        case APIRequestStatus.processing:
            return "Processing..."
        case APIRequestStatus.success:
            return "Successfully logged in."
        case APIRequestStatus.failure:
            return "Failed to \(isSigningUp ? "sign up" : "log in"). Please try again."
        default:
            return ""
        }
    }
    
    var body: some View {
        VStack {
            Section {
                Text("Log In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                TextField(text: $email, prompt: Text("Email")) {
                    Text("Email")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .autocapitalization(.none)
                
                SecureField(text: $password, prompt: Text("Password")) {
                    Text("Password")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .autocapitalization(.none)
                
                if (isSigningUp) {
                    SecureField(text: $confirmPassword, prompt: Text("Confirm Password")) {
                        Text("Confirm Password")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .autocapitalization(.none)
                }
                
                Button {
                    Task {
                        await signIn()
                    }
                } label: {
                    Text(isSigningUp ? "Sign Up" : "Log In")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .disabled(email.isEmpty || password.isEmpty || apiRequestStatus == APIRequestStatus.processing)
                
                if (!getStatusText().isEmpty) {
                    Text(getStatusText())
                }
                
                
                Button(isSigningUp ? "Already have an account? Log in instead." : "Need an account? Sign up instead.") {
                    isSigningUp.toggle()
                }
            }.padding(.horizontal, 10)
        }
    }
}
