//
//  APIErrorHandler.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 30/07/2025.
//

import Foundation

enum APIError: Error {
    case unauthorized               // 401
    case forbidden                  // 403
    case notFound                   // 404
    case conflict                   // 409
    case badRequest                 // 400
    case serverError                // 500+
    case unexpectedStatus(Int)     // Anything else
    case invalidResponse
}

struct APIErrorHandler {
    static func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200..<300:
            return
        case 400:
            throw APIError.badRequest
        case 401:
            throw APIError.unauthorized
        case 403:
            throw APIError.forbidden
        case 404:
            throw APIError.notFound
        case 409:
            throw APIError.conflict
        case 500...:
            throw APIError.serverError
        default:
            throw APIError.unexpectedStatus(httpResponse.statusCode)
        }
    }
}
