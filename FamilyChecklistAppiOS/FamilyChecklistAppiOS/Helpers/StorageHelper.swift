//
//  StorageHelper.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 30/07/2025.
//

import Foundation
import KeychainAccess

// Made this static for now might make it singleton once I have added the foundatiosn for that and need it for testing.

enum StorageHelper {
    private static let userDefaults = UserDefaults.standard
    private static let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "DefaultApp")

    // MARK: - Codable support (UserDefaults)
    // This will store different kinds of data so it needs to suport a range of types.

    static func save<T: Codable>(_ value: T, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(value) {
            userDefaults.set(encoded, forKey: key)
        }
    }

    static func get<T: Codable>(forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    static func delete(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }

    // MARK: - Secure String Storage (Keychain)
    // This is to store data that needs to be encripted and at this stage they all conform to string.

    static func saveSecure(_ value: String, forKey key: String) {
        do {
            try keychain.set(value, key: key)
        } catch {
            print("🔐 Keychain save failed: \(error)")
        }
    }

    static func getSecure(forKey key: String) -> String? {
        return try? keychain.get(key) ?? nil
    }

    static func deleteSecure(forKey key: String) {
        do {
            try keychain.remove(key)
        } catch {
            print("🔐 Keychain delete failed: \(error)")
        }
    }

    static func clearAllSecure() {
        do {
            try keychain.removeAll()
        } catch {
            print("🔐 Failed to clear Keychain: \(error)")
        }
    }
}

