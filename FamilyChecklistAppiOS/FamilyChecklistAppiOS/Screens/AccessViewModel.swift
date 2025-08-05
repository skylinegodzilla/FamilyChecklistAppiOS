//
//  AccessViewModel.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 30/07/2025.
//

import Foundation
// TODO: Sort out the valdation for the submit button

@MainActor
final class AccessViewModel: ObservableObject {

    // MARK: - Public Published State
    @Published
    private(set) var viewState: ViewState = ViewState.initial

    // MARK: - Private State
    private var model: Model {
        didSet {
            viewState = self.createViewState(from: model)
        }
    }

    private let authRepository: AuthRepository

    // MARK: - Init
    init(authRepository: AuthRepository = AuthRepository()) {
        self.authRepository = authRepository
        self.model = Model()
        self.viewState = self.createViewState(from: model)
    }

    // MARK: - Private State Mapping
    private func createViewState(from model: Model) -> ViewState {
        // TODO: tidy this validation up
        let isValid: Bool = {
            if model.usernameTextField.text.isEmpty || model.passwordTextField.text.isEmpty {
                return false
            }
            if model.isRegistering {
                return !model.emailTextField.text.isEmpty && model.passwordTextField.text == model.confirmPasswordTextField.text
            }
            return true
        }()
        // MARK: build Text field view states
        let usernameTextFieldViewState = createTextInputViewState(
            for: \Model.usernameTextField,
            label: "Name",
            validatorCondition: { !$0.isEmpty }
        )
        
        let emailTextFieldViewState = createTextInputViewState(
            for: \Model.emailTextField,
            label: "Email",
            validatorCondition: { $0.contains("@") && $0.contains(".") }
        )
        
        let passwordTextFieldViewState = createTextInputViewState(
            for: \Model.passwordTextField,
            label: "Password",
            validatorCondition: { $0.count >= 8 },
            isSecure: true
        )
        
        let confirmPasswordTextFieldViewState = createTextInputViewState(
            for: \Model.confirmPasswordTextField,
            label: "Confirm Password",
            validatorCondition: { !$0.isEmpty && $0 == self.model.passwordTextField.text },
            isSecure: true
        )
        
        // MARK: build other view states
        return ViewState(
            title: model.isRegistering ? "Register" : "Login", // TODO: Wonder if I should look in to localising strings?
            isRegistering: model.isRegistering,
            isLoading: model.isLoading,
            errorMessage: model.errorMessage,

            onToggleFormMode: { [weak self] in self?.toggleFormMode() },
            onSubmit: isValid ? { [weak self] in await self?.submit() } : nil,
            
            usernameTextFieldViewState: usernameTextFieldViewState,
            emailTextFieldViewState: emailTextFieldViewState,
            passwordTextFieldViewState: passwordTextFieldViewState,
            confirmPasswordTextFieldViewState: confirmPasswordTextFieldViewState
        )
    }

    // MARK: - Public Methods
    // None yet

    // MARK: - Private Logic
    private func createTextInputViewState(
        for keyPath: WritableKeyPath<Model, TextFieldModel>,
        label: String,
        validatorCondition: ((String) -> Bool)? = nil,
        isSecure: Bool = false
    ) -> TextFieldComponentViewState {
        let field = model[keyPath: keyPath]
        let validator = validatorCondition ?? field.validator

        let showError: Bool
        switch keyPath {
        case \Model.usernameTextField:
            showError = field.touched && !validator(field.text)

        case \Model.emailTextField:
            showError = field.touched && !validator(field.text)

        case \Model.passwordTextField:
            showError = field.touched && !validator(field.text)
            
        case \Model.confirmPasswordTextField:
            let isMatching = field.text == model.passwordTextField.text // TODO: why do I need validation here if I have the validatorCondition: { ... }
            if field.isFocused {
                showError = false
            } else {
                showError = field.touched && !isMatching
            }

        default:
            showError = false
        }

        return TextFieldComponentViewState(
            label: label,
            text: field.text,
            isValid: validator(field.text),
            showError: showError,
            isSecure: isSecure,
            onTextChanged: { [weak self] newText in
                guard let self = self else { return }
                self.model[keyPath: keyPath].updateText(newText)
            },
            onFocusChanged: { [weak self] focused in
                guard let self = self else { return }
                self.model[keyPath: keyPath].setFocus(focused)
            }
        )
    }
    
    private func toggleFormMode() {
        model.isRegistering.toggle()
        model.emailTextField.text = ""
        model.confirmPasswordTextField.text = ""
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
                    username: self.model.usernameTextField.text,
                    email: self.model.emailTextField.text,
                    password: self.model.passwordTextField.text
                )
                switch result {
                case .success(let response):
                    let username = self.model.usernameTextField.text
                    let session = AuthenticatedSession(token: response.token,
                                                       username: username, // TODO: yeahh I forgot my model structures lol I need to fix this messs :P
                                                       isAdmin: false // when an account is fresh created ashume that the user is not admin
                    )
                    SessionHelper.shared.saveSession(session) // TODO: Dependincey inject this
                    
                    //Navigate to TabView/HomeView on successful registration
                    await MainActor.run {
                        AppState.shared.flow = .tab
                    }
                    
                    print("✅ Registration successful")
                    break
                case .failure(let error):
                    var errorMessage = "\(error)"
                    if (errorMessage == "conflict") {errorMessage = "Username or email is allready taken" } // 409 error
                    self.model.errorMessage = errorMessage
                }
            } else {
                let result = await self.authRepository.login(
                    username: self.model.usernameTextField.text,
                    password: self.model.passwordTextField.text
                )
                switch result {
                case .success(let response):
                    let username = self.model.usernameTextField.text
                    let isAdmin = response.role == "ADMIN"
                    let session = AuthenticatedSession(token: response.token,
                                                       username: username, // TODO: yeahh I forgot my model structures lol I need to fix this messs :P
                                                       isAdmin: isAdmin
                    )
                    SessionHelper.shared.saveSession(session) // TODO: Dependincey inject this
                    
                    // Navigate to TabView/HomeView on successful login
                    await MainActor.run {
                        AppState.shared.flow = .tab
                    }
                    print("✅ Login successful")
                    
                case .failure(let error):
                    var errorMessage = "\(error)"
                    if (errorMessage == "unauthorized") {errorMessage = "Invalid credentials" } // 401 error
                    self.model.errorMessage = errorMessage
                }
            }
        }
    }


    // MARK: - Internal Structs

    private struct Model {
        var isRegistering: Bool = false
        var isLoading: Bool = false
        var errorMessage: String? = nil
        
        var usernameTextField: TextFieldModel = TextFieldModel()
        var emailTextField: TextFieldModel = TextFieldModel()
        var passwordTextField: TextFieldModel = TextFieldModel()
        var confirmPasswordTextField: TextFieldModel = TextFieldModel()
    }
    
    struct ViewState {
        var title: String
        var isRegistering: Bool
        var isLoading: Bool
        var errorMessage: String?

        let onToggleFormMode: () -> Void
        let onSubmit: (() async -> Void)?
        
        let usernameTextFieldViewState: TextFieldComponentViewState
        let emailTextFieldViewState: TextFieldComponentViewState
        let passwordTextFieldViewState: TextFieldComponentViewState
        let confirmPasswordTextFieldViewState: TextFieldComponentViewState

        static let initial = ViewState(
            title: "Login",
            isRegistering: false,
            isLoading: false,
            errorMessage: nil,
            onToggleFormMode: { },
            onSubmit: nil,
            
            usernameTextFieldViewState: TextFieldComponentViewState(
                label: "",
                text: "",
                isValid: true,
                showError: false,
                isSecure: false,
                onTextChanged: { _ in },
                onFocusChanged: { _ in }
            ),
            emailTextFieldViewState: TextFieldComponentViewState(
                label: "",
                text: "",
                isValid: true,
                showError: false,
                isSecure: false,
                onTextChanged: { _ in },
                onFocusChanged: { _ in }
            ),
            passwordTextFieldViewState: TextFieldComponentViewState(
                label: "",
                text: "",
                isValid: true,
                showError: false,
                isSecure: false,
                onTextChanged: { _ in },
                onFocusChanged: { _ in }
            ),
            confirmPasswordTextFieldViewState: TextFieldComponentViewState(
                label: "",
                text: "",
                isValid: true,
                showError: false,
                isSecure: false,
                onTextChanged: { _ in },
                onFocusChanged: { _ in }
            )
        )
    }

}
