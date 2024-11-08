//
//  LoginSignUpApi.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//

import Foundation

class LoginSignUpApi {
    public func signIn(email: String, password: String) async throws -> Bool {
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
        }
        
        return false;
    }
    
}

