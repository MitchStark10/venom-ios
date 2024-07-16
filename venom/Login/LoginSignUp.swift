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
    @State private var apiRequestStatus: APIRequestStatus = APIRequestStatus.initial
    @Binding public var hasSignedIn: Bool
    
    private func signIn() async -> Void {
        do {
            apiRequestStatus = APIRequestStatus.processing
            let didLoginSucceed = try await LoginSignUpApi().signIn(email: email, password: password)
            
            if (didLoginSucceed) {
                apiRequestStatus = APIRequestStatus.success
                hasSignedIn = true;
            } else {
                apiRequestStatus = APIRequestStatus.failure
            }
        } catch _ {
            apiRequestStatus = APIRequestStatus.failure
        }
    }
    
    private func getStatusText () -> String {
        switch apiRequestStatus {
        case APIRequestStatus.processing:
            return "Processing..."
        case APIRequestStatus.success:
            return "Successfully logged in."
        case APIRequestStatus.failure:
            return "Failed to log in. Please try again."
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
                
                Button {
                    Task {
                        await signIn()
                    }
                } label: {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .disabled(email.isEmpty || password.isEmpty || apiRequestStatus == APIRequestStatus.processing)
                
                if (!getStatusText().isEmpty) {
                    Text(getStatusText())
                }
            }.padding(.horizontal, 10)
        }
    }
}

#Preview {
    LoginSignUp(hasSignedIn: .constant(true))
}
