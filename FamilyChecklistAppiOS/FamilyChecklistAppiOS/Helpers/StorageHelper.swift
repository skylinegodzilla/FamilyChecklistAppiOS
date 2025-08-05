//
//  StorageHelper.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 30/07/2025.
//

import Foundation
import KeychainAccess

final class StorageHelper {
    static let shared = StorageHelper()
    
    private let userDefaults: UserDefaults
    private let keychain: Keychain

    // Private init to enforce singleton
    private init(userDefaults: UserDefaults = .standard,
                 keychain: Keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "DefaultApp")) {
        self.userDefaults = userDefaults
        self.keychain = keychain
    }

    // MARK: - Codable support (UserDefaults)

    func save<T: Codable>(_ value: T, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(value) {
            userDefaults.set(encoded, forKey: key)
        }
    }

    func get<T: Codable>(forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func delete(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }

    // MARK: - Secure String Storage (Keychain)

    func saveSecure(_ value: String, forKey key: String) {
        do {
            try keychain.set(value, key: key)
        } catch {
            print("🔐 Keychain save failed: \(error)")
        }
    }

    func getSecure(forKey key: String) -> String? {
        return try? keychain.get(key) ?? nil
    }

    func deleteSecure(forKey key: String) {
        do {
            try keychain.remove(key)
        } catch {
            print("🔐 Keychain delete failed: \(error)")
        }
    }

    func clearAllSecure() {
        do {
            try keychain.removeAll()
        } catch {
            print("🔐 Failed to clear Keychain: \(error)")
        }
    }
}
