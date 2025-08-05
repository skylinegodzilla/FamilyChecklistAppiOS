//
//  FamilyChecklistAppiOSApp.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 29/07/2025.
//

import SwiftUI
import Foundation

@main
struct FamilyChecklistAppiOSApp: App {
    @StateObject private var appState = AppState.shared

    var body: some Scene {
        WindowGroup {
            switch appState.flow {
            case .login:
                AccessView()
            case .tab:
                RootTabView()
            }
        }
    }
}

// TODO: this might be messy to dump it here but its fine for now
@MainActor
final class AppState: ObservableObject {
    enum Flow {
        case login
        case tab
    }

    @Published var flow: Flow = .login

    static let shared = AppState()
}

