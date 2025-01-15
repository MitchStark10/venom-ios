//
//  LoginSignUpApi.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//

import Foundation

class LoginSignUpApi: ApiClient, ObservableObject, @unchecked Sendable {
    @Published var isLoggedIn: Bool = initializeSignInStatus()
    @Published var errorMessage: String = ""
    
    private func signUpOrIn(email: String, password: String, url: URL) async throws -> Bool {
         DispatchQueue.main.async {
            self.errorMessage = ""
        }
        let rawRequestBody = ["email": email, "password": password]
        let data = try await sendApiCall(
            url: url,
            requestMethod: "POST",
            requestBody: rawRequestBody,
            toastOnError: false
        )
        let loginSignUpResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
        
        if loginSignUpResponse.token != nil {
            if let data = loginSignUpResponse.token!.data(using: .utf8) {
                let status = KeychainHelper.shared.save(key: Constants.accessTokenKeychainKey, data: data)
                if status == errSecSuccess {
                    return true
                }
            }
            
            return false
        } else if loginSignUpResponse.error != nil {
            DispatchQueue.main.async {
                self.errorMessage = loginSignUpResponse.error!
            }
        }
        
        return false       
    }
    
    public func signIn(email: String, password: String) async throws -> Bool {
        return try await signUpOrIn(email: email, password: password, url: Constants.loginUrl!)
    }
    
    public func signUp(email: String, password: String) async throws -> Bool {
        return try await signUpOrIn(email: email, password: password, url: Constants.signUpUrl!)
    }
    
    @discardableResult
    public func signOut() -> Bool {
        let status = KeychainHelper.shared.delete(key: Constants.accessTokenKeychainKey)
        if status == errSecSuccess {
            return true
        }
        
        return false
    }
    
}
