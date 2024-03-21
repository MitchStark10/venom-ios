//
//  LoginSignUp.swift
//  venom
//
//  Created by Mitch Stark on 3/19/24.
//
import SwiftUI


enum APIRequestStatus {
    case initial
    case processing
    case success
    case failure
}

struct LoginSignUp: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var apiRequestStatus: APIRequestStatus = APIRequestStatus.initial
    
    private func signIn() -> Void {
        print("Beginning sign in")
        var urlRequest = URLRequest(url: Constants.loginUrl!)
        urlRequest.httpMethod = "POST"
        let rawRequestBody = [email, password]
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: rawRequestBody)
        } catch let error {
            print(error.localizedDescription)
            apiRequestStatus = APIRequestStatus.failure
            return
        }
        
        apiRequestStatus = APIRequestStatus.processing
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            
            if let error = error {
                print("Request error: ", error)
                apiRequestStatus = APIRequestStatus.failure
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if (response.statusCode == 200) {
                // TODO: Return to parent view?
                apiRequestStatus = APIRequestStatus.success
            } else {
                print("Incorrect status code", response.statusCode)
                apiRequestStatus = APIRequestStatus.failure
            }
        }
        
        dataTask.resume()
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
            Button(action: signIn) {
                Text("Sign In")
            }.disabled(email.isEmpty || password.isEmpty)
            
            if (!getStatusText().isEmpty) {
                Text(getStatusText())
            }
            
        }.background(.white)
    }
}

#Preview {
    LoginSignUp()
}