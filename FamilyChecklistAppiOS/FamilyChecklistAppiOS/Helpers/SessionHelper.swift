//
//  SessionHelper.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 30/07/2025.
//

struct AuthenticatedSession: Codable {
    let token: String   // Stored securely in Keychain
    let username: String  // Stored in UserDefaults
    let isAdmin: Bool     // Stored in UserDefaults
}

enum SessionHelper {
    // Only SessionHelper should directly access these storage keys
    private static let tokenKey = "sessionToken"
    private static let usernameKey = "sessionUsername"
    private static let isAdminKey = "sessionIsAdmin"

    // Save session values to storage from a successful login response
    static func saveSession(_ session: AuthenticatedSession) {
        StorageHelper.save(session.username, forKey: usernameKey)
        StorageHelper.save(session.isAdmin, forKey: isAdminKey)
        StorageHelper.saveSecure(session.token, forKey: tokenKey)
    }

    // Returns an AuthenticatedSession only if all required values exist in storage
    static func getSession() -> AuthenticatedSession? {
        let username = StorageHelper.get(forKey: usernameKey) as String?
        let isAdmin = StorageHelper.get(forKey: isAdminKey) as Bool?
        let token = StorageHelper.getSecure(forKey: tokenKey)

        guard let username,
              let isAdmin,
              let token else {
            // some logging here so that we can see what is missing
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

    // Clears all session-related values from storage
    static func clearSession() {
        StorageHelper.delete(forKey: usernameKey)
        StorageHelper.delete(forKey: isAdminKey)
        StorageHelper.deleteSecure(forKey: tokenKey)
    }
}

