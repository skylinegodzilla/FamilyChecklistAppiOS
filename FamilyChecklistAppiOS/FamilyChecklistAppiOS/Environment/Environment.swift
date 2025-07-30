//
//  Environment.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 30/07/2025.
//

import Foundation

enum AppEnvironment {
    case DEV, UAT, PROD

    static var current: AppEnvironment {
        #if DEBUG
        return .DEV
        #elseif UAT
        return .UAT
        #else
        return .PROD
        #endif
    }

    var baseURL: String {
        switch self {
        case .DEV: return "http://localhost:8080"// Locval version of the server running in intilj with h2 DB or docker with Real DB
        case .UAT: return "http://192.168.1.236:8080" // This is hardcoded because its pointing to my local server
        case .PROD: return "http://192.168.1.236:8080"
        }
    }
}
