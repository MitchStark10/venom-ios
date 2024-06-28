//
//  insertToken.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//

import Foundation

/// Errors that can be thrown when the Keychain is queried.
enum KeychainError: LocalizedError {
    /// The requested item was not found in the Keychain.
    case itemNotFound
    /// Update the item instead.
    case duplicateItem
    /// The operation resulted in an unexpected status.
    case unexpectedStatus
}

func insertToken(_ token: Data, identifier: String) throws {
    let attributes = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: "com.venom.venom",
        kSecAttrAccount: identifier,
        kSecValueData: token
    ] as CFDictionary

    let status = SecItemAdd(attributes, nil)
    guard status == errSecSuccess else {
        if status == errSecDuplicateItem {
            throw KeychainError.duplicateItem
        }
        throw KeychainError.unexpectedStatus
    }
}
