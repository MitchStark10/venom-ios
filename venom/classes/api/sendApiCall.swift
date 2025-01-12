//
//  BaseApi.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//

import Foundation

@discardableResult
func sendApiCall(
    url: URL, requestMethod: String,
    requestBody: Any? = nil,
    requestOptions: RequestOptions = RequestOptions()
) async throws -> Data {
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = requestMethod
    
    if requestBody != nil {
        if requestOptions.verboseLogging {
            print("Request body: \(requestBody!)")
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
        if !(200...299).contains(httpResponse.statusCode) && requestOptions.toastOnErrors {
            // TODO: Toast this error or the fallback error
            showTextAtPoint(self: <#T##CGContext#>, x: <#T##CGFloat#>, y: <#T##CGFloat#>, string: <#T##Int8#>, length: <#T##Int#>)
        }
    }
    
    if requestOptions.verboseLogging {
        let outputStr  = String(data: data, encoding: String.Encoding.utf8)
        print("Response body: \(outputStr!)")
    }
    
    return data
}
