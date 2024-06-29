//
//  BaseApi.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//

import Foundation

func sendApiCall(url: URL, requestMethod: String, requestBody: Any?) async throws -> Data {
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = requestMethod
    if (requestBody != nil) {
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody!)
        urlRequest.httpBody = jsonData
        urlRequest.setValue("\(String(describing: jsonData.count))", forHTTPHeaderField: "Content-Length")
    }
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let session = URLSession.shared
    let (data, _) = try await session.data(for: urlRequest)
    return data;
}
