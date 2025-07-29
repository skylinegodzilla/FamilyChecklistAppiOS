//
//  AuthRepository.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 29/07/2025.
//

import Foundation

protocol AuthRepositoryProtocol {
    func login(username: String, password: String) async throws -> UserLoginResponse
    func register(
        username: String,
        email: String,
        password: String
    ) async throws -> UserRegistrationResponse
    func logout(token: String) async throws -> LogoutResponse
    func getUserInfo(token: String) async throws -> UserInfoResponse
}

struct UserLoginRequest: Codable {
    let username: String
    let password: String
}

struct UserLoginResponse: Codable {
    let token: String
    let status: Int
    let message: String
    let role: String
}

struct UserRegistrationRequest: Codable {
    let username: String
    let email: String
    let password: String
}

struct UserRegistrationResponse: Codable {
    let token: String
    let status: Int
    let message: String
}

struct LogoutResponse: Codable {
    let success: Bool
    let message: String
}

struct UserInfoResponse: Codable {
    let username: String
    let email: String
    let role: String
}

final class AuthRepository: AuthRepositoryProtocol {
    
    private let baseURL: String
    private let jsonDecoder = JSONDecoder()
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }

    func login(username: String, password: String) async throws -> UserLoginResponse {
        let requestPayload = UserLoginRequest(username: username, password: password)
        let request = try RequestBuilder(baseURL: baseURL, path: "/api/auth/login")
            .setMethod("POST")
            .setJSONBody(requestPayload)
            .build()

        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response: response)
        return try jsonDecoder.decode(UserLoginResponse.self, from: data)
    }

    func register(
        username: String,
        email: String,
        password: String
    ) async throws -> UserRegistrationResponse {
        let requestPayload = UserRegistrationRequest(
            username: username,
            email: email,
            password: password
        )
        let request = try RequestBuilder(baseURL: baseURL, path: "/api/auth/register")
            .setMethod("POST")
            .setJSONBody(requestPayload)
            .build()

        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response: response)
        return try jsonDecoder.decode(UserRegistrationResponse.self, from: data)
    }

    func logout(token: String) async throws -> LogoutResponse {
        let request = try RequestBuilder(baseURL: baseURL, path: "/api/auth/logout")
            .setMethod("POST")
            .addAuthorization(token: token)
            .build()

        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response: response)
        return try jsonDecoder.decode(LogoutResponse.self, from: data)
    }

    func getUserInfo(token: String) async throws -> UserInfoResponse {
        let request = try RequestBuilder(baseURL: baseURL, path: "/api/auth/userinfo")
            .setMethod("GET")
            .addAuthorization(token: token)
            .build()

        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response: response)
        return try jsonDecoder.decode(UserInfoResponse.self, from: data)
    }
    
    // MARK: - Helpers
    
    private func validate(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil)
        }
    }
}
