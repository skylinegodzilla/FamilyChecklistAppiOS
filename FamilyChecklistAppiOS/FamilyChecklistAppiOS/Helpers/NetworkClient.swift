//
//  NetworkClient.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 30/07/2025.
//

import Foundation

protocol NetworkClientProtocol {
    func performRequest<T: Decodable>(_ request: URLRequest) async -> Result<T, Error>
}

actor NetworkClient: NetworkClientProtocol {
    static let shared: NetworkClientProtocol = NetworkClient()
    private let jsonDecoder = JSONDecoder()

    func performRequest<T: Decodable>(_ request: URLRequest) async -> Result<T, Error> {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            try APIErrorHandler.validate(response)
            let decoded = try jsonDecoder.decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }
}
