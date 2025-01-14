//
//  BaseApi.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//

import Foundation

struct ErrorResponse: Decodable {
    let message: String
}

class ApiClient: @unchecked Sendable {
    
    var globalMessages: GlobalMessages
    
    init(_ globalMessages: GlobalMessages) {
        self.globalMessages = globalMessages
    }
    
    @discardableResult
    func sendApiCall(
        url: URL, requestMethod: String,
        requestBody: Any? = nil,
        verboseLogging: Bool = false,
        toastOnError: Bool = true,
        fallbackErrorMesssage: String = "An error occurred."
    ) async throws -> Data {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestMethod
        
        if requestBody != nil {
            if verboseLogging {
                venomLogger.info("Request body: \(String(describing: requestBody!))")
            }
            
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody!)
            urlRequest.httpBody = jsonData
            urlRequest.setValue("\(String(describing: jsonData.count))", forHTTPHeaderField: "Content-Length")
        }
        
        let accessToken = getToken()
        
        if accessToken != nil {
            let formattedAccessToken = "Bearer \(accessToken!)"
            urlRequest.setValue(formattedAccessToken, forHTTPHeaderField: "Authorization")
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let (data, response) = try await session.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            if !(200...299).contains(httpResponse.statusCode) && toastOnError {
                venomLogger.error("HTTP Error \(httpResponse.statusCode) received from \(url).")
                
                DispatchQueue.main.async {
                    do {
                        let parsedErrorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        self.globalMessages.alertMessage = parsedErrorResponse.message
                    } catch {
                        self.globalMessages.alertMessage = fallbackErrorMesssage
                    }
                    
                    self.globalMessages.showAlert = true
                }
            }
        }
        
        if verboseLogging {
            let outputStr  = String(data: data, encoding: String.Encoding.utf8)
            venomLogger.info("Response body: \(outputStr!)")
        }
        
        return data
    }
}
