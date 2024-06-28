//
//  LoginSignUpApi.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//

import Foundation

class LoginSignUpApi {
    public func signIn(email: String, password: String) async throws -> Bool {
        var urlRequest = URLRequest(url: Constants.loginUrl!)
        urlRequest.httpMethod = "POST"
        let rawRequestBody = ["email": email, "password":  password]
        let jsonData = try JSONSerialization.data(withJSONObject: rawRequestBody)
        urlRequest.httpBody = jsonData
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("\(String(describing: jsonData.count))", forHTTPHeaderField: "Content-Length")

        let session = URLSession.shared
        let (data, _) = try await session.data(for: urlRequest)
        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
        
        if (loginResponse.token != nil) {
            if let data = loginResponse.token!.data(using: .utf8) {
                let status = KeychainHelper.shared.save(key: "accessToken", data: data)
                if status == errSecSuccess {
                    return true
                }
            }
            
            return false;
        }
        
        return false;
    }
    
}

