//
//  KeychainService.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-03.
//

import Foundation
import Security

class KeychainService {
    static let shared = KeychainService()

    func saveToken(_ token: String) {
        let data = Data(token.utf8)
        let query = [
            kSecValueData: data,
            kSecAttrAccount: "userToken",
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: "ConnectEDU",
        ] as [String: Any]

        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    func retrieveToken() -> String? {
        let query = [
            kSecAttrAccount: "userToken",
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: "ConnectEDU",
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne,
        ] as [String: Any]

        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            if let data = dataTypeRef as? Data {
                // print("Data: \(String(data: data, encoding: .utf8))")
                return String(data: data, encoding: .utf8)
            }
        }
//        NavigationManager.shared.navigate(to: .login)
        return nil
    }

    func deleteToken() {
        let query = [
            kSecAttrAccount: "userToken",
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: "ConnectEDU",
        ] as [String: Any]

        SecItemDelete(query as CFDictionary)
    }
}
