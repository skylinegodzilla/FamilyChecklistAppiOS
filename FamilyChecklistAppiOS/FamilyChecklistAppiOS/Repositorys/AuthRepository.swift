//
//  AuthRepository.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 29/07/2025.
//

import Foundation

protocol AuthRepositoryProtocol {
    func login(username: String, password: String) async -> Result<UserLoginResponse, Error>
    func register(username: String, email: String, password: String) async -> Result<UserRegistrationResponse, Error>
    func logout(token: String) async -> Result<LogoutResponse, Error>
    func getUserInfo(token: String) async -> Result<UserInfoResponse, Error>
}

// - MARK: Login structs
struct UserLoginRequest: Codable, Sendable {
    let username: String
    let password: String
}

struct UserLoginResponse: Codable, Sendable {
    let token: String
    let status: Int
    let message: String
    let role: String
}

// - MARK: Registration structs
struct UserRegistrationRequest: Codable, Sendable {
    let username: String
    let email: String
    let password: String
}

struct UserRegistrationResponse: Codable, Sendable {
    let token: String
    let status: Int
    let message: String
}

// - MARK: Logout structs
struct LogoutResponse: Codable, Sendable {
    let success: Bool
    let message: String
}

// - MARK: UserInfo structs
// TODO: go back and look up how you built this endpoint make shure that users cant fetch other users info unless they are admin
struct UserInfoResponse: Codable, Sendable {
    let username: String
    let email: String
    let role: String
}

final actor AuthRepository: AuthRepositoryProtocol {
    
    private let baseURL: String
    private let jsonDecoder = JSONDecoder()
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }

    func login(username: String, password: String) async -> Result<UserLoginResponse, Error> {
        do {
            let requestPayload = UserLoginRequest(username: username, password: password)
            let request = try RequestBuilder(baseURL: baseURL, path: "/api/auth/login")
                .setMethod("POST")
                .setJSONBody(requestPayload)
                .build()
            let (data, response) = try await URLSession.shared.data(for: request)
            try APIErrorHandler.validate(response)
            let decoded = try jsonDecoder.decode(UserLoginResponse.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }

    func register(username: String, email: String, password: String) async -> Result<UserRegistrationResponse, Error> {
        do {
            let requestPayload = UserRegistrationRequest(username: username, email: email, password: password)
            let request = try RequestBuilder(baseURL: baseURL, path: "/api/auth/register")
                .setMethod("POST")
                .setJSONBody(requestPayload)
                .build()
            let (data, response) = try await URLSession.shared.data(for: request)
            try APIErrorHandler.validate(response)
            let decoded = try jsonDecoder.decode(UserRegistrationResponse.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }

    func logout(token: String) async -> Result<LogoutResponse, Error> {
        do {
            let request = try RequestBuilder(baseURL: baseURL, path: "/api/auth/logout")
                .setMethod("POST")
                .addAuthorization(token: token)
                .build()
            let (data, response) = try await URLSession.shared.data(for: request)
            try APIErrorHandler.validate(response)
            let decoded = try jsonDecoder.decode(LogoutResponse.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }

    func getUserInfo(token: String) async -> Result<UserInfoResponse, Error> {
        do {
            let request = try RequestBuilder(baseURL: baseURL, path: "/api/auth/userinfo")
                .setMethod("GET")
                .addAuthorization(token: token)
                .build()
            let (data, response) = try await URLSession.shared.data(for: request)
            try APIErrorHandler.validate(response)
            let decoded = try jsonDecoder.decode(UserInfoResponse.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }
}
