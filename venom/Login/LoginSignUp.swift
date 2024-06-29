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
        Form {
            TextField(text: $email, prompt: Text("Required")) {
                Text("Email")
            }
            SecureField(text: $password, prompt: Text("Required")) {
                Text("Password")
            }
            Button {
                Task {
                    await signIn()
                }
            } label: {
                Text("Login")
            }
            .disabled(email.isEmpty || password.isEmpty || apiRequestStatus == APIRequestStatus.processing)
            
            if (!getStatusText().isEmpty) {
                Text(getStatusText())
            }
            
        }.background(.white)
    }
}

#Preview {
    LoginSignUp(hasSignedIn: .constant(true))
}
