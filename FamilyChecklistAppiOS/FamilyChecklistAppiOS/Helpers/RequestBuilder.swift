//
//  RequestBuilder.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 29/07/2025.
//

import Foundation

final class RequestBuilder {
    private var urlComponents: URLComponents
    private var method: String = "GET"
    private var headers: [String: String] = [:]
    private var body: Data?

    init(baseURL: String, path: String) {
        guard let components = URLComponents(string: baseURL) else {
            fatalError("Invalid base URL")
        }
        self.urlComponents = components
        self.urlComponents.path = path
    }

    func setMethod(_ method: String) -> Self {
        self.method = method
        return self
    }

    func addHeader(name: String, value: String) -> Self {
        headers[name] = value
        return self
    }

    func addAuthorization(token: String) -> Self {
        headers["Authorization"] = token
        return self
    }

    func setJSONBody<T: Encodable>(_ bodyObject: T) throws -> Self {
        let encoder = JSONEncoder()
        self.body = try encoder.encode(bodyObject)
        addHeader(name: "Content-Type", value: "application/json")
        return self
    }

    func build() throws -> URLRequest {
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = body

        return request
    }
}
