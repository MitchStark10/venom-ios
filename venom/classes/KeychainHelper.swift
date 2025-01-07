//
//  KeychainHelper.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//

import Foundation
import Security

class KeychainHelper {

    static let shared = KeychainHelper()
    private init() {}

    func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query)
        return SecItemAdd(query, nil)
    }

    func load(key: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query, &dataTypeRef)

        if status == noErr, let data = dataTypeRef as? Data {
            return data
        } else {
            return nil
        }
    }

    func delete(key: String) -> OSStatus {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        return SecItemDelete(query)
    }
}
