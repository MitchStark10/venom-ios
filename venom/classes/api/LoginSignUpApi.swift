//
//  LoginSignUpApi.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//

import Foundation

class LoginSignUpApi: ObservableObject, @unchecked Sendable {
    @Published var isLoggedIn: Bool = initializeSignInStatus()
    @Published var errorMessage: String = ""
    
    public func signIn(email: String, password: String) async throws -> Bool {
        DispatchQueue.main.async {
            self.errorMessage = ""
        }
        let rawRequestBody = ["email": email, "password": password]
        let data = try await sendApiCall(url: Constants.loginUrl!, requestMethod: "POST", requestBody: rawRequestBody)
        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
        
        if (loginResponse.token != nil) {
            if let data = loginResponse.token!.data(using: .utf8) {
                let status = KeychainHelper.shared.save(key: Constants.accessTokenKeychainKey, data: data)
                if status == errSecSuccess {
                    return true
                }
            }
            
            return false;
        } else if (loginResponse.error != nil) {
            DispatchQueue.main.async {
                self.errorMessage = loginResponse.error!
            }
        }
        
        return false;
    }
    
    public func signUp(email: String, password: String) async throws -> Bool {
        DispatchQueue.main.async {
            self.errorMessage = ""
        }
        let rawRequestBody = ["email": email, "password": password]
        let data = try await sendApiCall(url: Constants.signUpUrl!, requestMethod: "POST", requestBody: rawRequestBody)
        let signUpResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
        
        if (signUpResponse.token != nil) {
            if let data = signUpResponse.token!.data(using: .utf8) {
                let status = KeychainHelper.shared.save(key: Constants.accessTokenKeychainKey, data: data)
                if status == errSecSuccess {
                    return true
                }
            }
            
            return false;
        } else if (signUpResponse.error != nil) {
            DispatchQueue.main.async {
                self.errorMessage = signUpResponse.error!
            }
        }
        
        return false;
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

