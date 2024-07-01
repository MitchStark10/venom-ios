//
//  initializeSignInStatus.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//

import Foundation

func getToken() -> String? {
    if let data = KeychainHelper.shared.load(key: Constants.accessTokenKeychainKey),
       let token = String(data: data, encoding: .utf8) {
        return token
    } else {
        print("Failed to retrieve token")
        return nil
    }
}

func initializeSignInStatus() -> Bool {
    return getToken() != nil;
}
