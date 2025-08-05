//
//  SessionHelper.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 30/07/2025.
//

import Foundation

struct AuthenticatedSession: Codable {
    let token: String   // Stored securely in Keychain
    let username: String  // Stored in UserDefaults
    let isAdmin: Bool     // Stored in UserDefaults
}

final class SessionHelper {
    static let shared = SessionHelper()

    // MARK: - Storage keys (private)
    private let tokenKey = "sessionToken"
    private let usernameKey = "sessionUsername"
    private let isAdminKey = "sessionIsAdmin"

    private let storage: StorageHelper

    // Private init for singleton, inject storageHelper for testability
    private init(storageHelper: StorageHelper = StorageHelper.shared) {
        self.storage = storageHelper
    }

    // MARK: - Session Management

    func saveSession(_ session: AuthenticatedSession) {
        storage.save(session.username, forKey: usernameKey)
        storage.save(session.isAdmin, forKey: isAdminKey)
        storage.saveSecure(session.token, forKey: tokenKey)
    }

    func getSession() -> AuthenticatedSession? {
        let username: String? = storage.get(forKey: usernameKey)
        let isAdmin: Bool? = storage.get(forKey: isAdminKey)
        let token: String? = storage.getSecure(forKey: tokenKey)

        guard let username,
              let isAdmin,
              let token else {
            var missing: [String] = []
            if username == nil { missing.append("username") }
            if isAdmin == nil { missing.append("isAdmin") }
            if token == nil { missing.append("token") }
            print("SessionHelper: Missing from storage → \(missing.joined(separator: ", "))")
            return nil
        }

        return AuthenticatedSession(
            token: token,
            username: username,
            isAdmin: isAdmin
        )
    }

    func clearSession() {
        storage.delete(forKey: usernameKey)
        storage.delete(forKey: isAdminKey)
        storage.deleteSecure(forKey: tokenKey)
    }
}
