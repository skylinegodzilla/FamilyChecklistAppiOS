//
//  AccessViewModel.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 30/07/2025.
//

import Foundation

//
//  AccessViewModel.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 30/07/2025.
//

import Foundation

@MainActor
final class AccessViewModel: ObservableObject {

    // MARK: - Public Published State
    @Published private(set) var viewState: ViewState = ViewState.initial

    // MARK: - Private State
    private var model: Model {
        didSet {
            viewState = Self.createViewState(from: model, viewModel: self)
        }
    }

    private let authRepository: AuthRepository

    // MARK: - Init
    init(authRepository: AuthRepository = AuthRepository()) {
        self.authRepository = authRepository
        self.model = Model()
        self.viewState = Self.createViewState(from: model, viewModel: self)
    }

    // MARK: - Private State Mapping
    private static func createViewState(from model: Model, viewModel: AccessViewModel) -> ViewState {
        let isValid: Bool = {
            if model.username.isEmpty || model.password.isEmpty {
                return false
            }
            if model.isRegistering {
                return !model.email.isEmpty && model.password == model.confirmPassword
            }
            return true
        }()

        return ViewState(
            username: model.username,
            email: model.email,
            password: model.password,
            confirmPassword: model.isRegistering ? model.confirmPassword : nil,
            isRegistering: model.isRegistering,
            isLoading: model.isLoading,
            errorMessage: model.errorMessage,

            onUsernameChange: { [weak viewModel] in viewModel?.updateUsername($0) },
            onEmailChange: { [weak viewModel] in viewModel?.updateEmail($0) },
            onPasswordChange: { [weak viewModel] in viewModel?.updatePassword($0) },
            onConfirmPasswordChange: { [weak viewModel] in viewModel?.updateConfirmPassword($0) },
            onToggleFormMode: { [weak viewModel] in viewModel?.toggleFormMode() },
            onSubmit: isValid ? { [weak viewModel] in await viewModel?.submit() } : nil
        )
    }

    // MARK: - Public Methods
    // None yet

    // MARK: - Private Logic
    private func updateUsername(_ value: String) { model.username = value }
    private func updateEmail(_ value: String) { model.email = value }
    private func updatePassword(_ value: String) { model.password = value }
    private func updateConfirmPassword(_ value: String) { model.confirmPassword = value }

    private func toggleFormMode() {
        model.isRegistering.toggle()
        model.email = ""
        model.confirmPassword = ""
        model.errorMessage = nil
    }

    private func submit() {
        model.isLoading = true
        model.errorMessage = nil

        Task { [weak self] in
            guard let self = self else { return }

            defer { self.model.isLoading = false }

            if self.model.isRegistering {
                let result = await self.authRepository.register(
                    username: self.model.username,
                    email: self.model.email,
                    password: self.model.password
                )
                switch result {
                case .success:
                    // TODO: Navigate to TabView/HomeView on successful registration
                    break
                case .failure(let error):
                    self.model.errorMessage = error.localizedDescription
                }
            } else {
                let result = await self.authRepository.login(
                    username: self.model.username,
                    password: self.model.password
                )
                switch result {
                case .success:
                    // TODO: Navigate to TabView/HomeView on successful login
                    break // handle success if needed
                case .failure(let error):
                    self.model.errorMessage = error.localizedDescription
                }
            }
        }
    }


    // MARK: - Internal Structs

    private struct Model {
        var username: String = ""
        var email: String = ""
        var password: String = ""
        var confirmPassword: String = ""
        var isRegistering: Bool = false
        var isLoading: Bool = false
        var errorMessage: String? = nil
    }
    
    struct ViewState {
        var username: String
        var email: String
        var password: String
        var confirmPassword: String?
        var isRegistering: Bool
        var isLoading: Bool
        var errorMessage: String?

        let onUsernameChange: (String) -> Void
        let onEmailChange: (String) -> Void
        let onPasswordChange: (String) -> Void
        let onConfirmPasswordChange: (String) -> Void
        let onToggleFormMode: () -> Void
        let onSubmit: (() async -> Void)?

        static let initial = ViewState(
            username: "",
            email: "",
            password: "",
            confirmPassword: nil,
            isRegistering: false,
            isLoading: false,
            errorMessage: nil,
            onUsernameChange: { _ in },
            onEmailChange: { _ in },
            onPasswordChange: { _ in },
            onConfirmPasswordChange: { _ in },
            onToggleFormMode: { },
            onSubmit: nil
        )
    }

}
