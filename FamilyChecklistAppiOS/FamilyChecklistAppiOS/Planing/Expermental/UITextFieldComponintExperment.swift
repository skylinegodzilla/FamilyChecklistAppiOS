//
//  UITextFieldComponentExperiment.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 03/08/2025.
//

import SwiftUICore
import SwiftUI

//// MARK: - TextInputComponentViewState
//
//struct TextInputComponentViewState {
//    let label: String
//    let text: String
//    let isValid: Bool
//    let showError: Bool
//    let isSecure: Bool
//    let onTextChanged: (String) -> Void
//    let onFocusChanged: (Bool) -> Void
//}
//
//// MARK: - TextInputComponentModel
//
//struct TextFieldModel {
//    var text: String = ""
//    var touched: Bool = false
//    var isFocused: Bool = false
//
//    let validator: (String) -> Bool
//
//    init(text: String = "", validator: @escaping (String) -> Bool = { _ in true }) {
//        self.text = text
//        self.validator = validator
//    }
//
//    mutating func updateText(_ newText: String) {
//        self.text = newText
//    }
//
//    mutating func setTouched() {
//        self.touched = true
//    }
//
//    mutating func setFocus(_ focused: Bool) {
//        self.isFocused = focused
//        if !focused {
//            setTouched()
//        }
//    }
//
//    var isValid: Bool {
//        validator(text)
//    }
//}
//
//// MARK: - TextInputComponent
//
//struct TextInputComponent: View {
//    let viewState: TextInputComponentViewState
//    @FocusState private var isFocused: Bool
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            Text(viewState.label)
//                .font(.caption)
//                .foregroundColor(.secondary)
//
//            if viewState.isSecure {
//                SecureField("Enter value", text: Binding(
//                    get: { viewState.text },
//                    set: { viewState.onTextChanged($0) }
//                ))
//                .textFieldStyle(.roundedBorder)
//                .focused($isFocused)
//                .onChange(of: isFocused) { focused in
//                    viewState.onFocusChanged(focused)
//                }
//            } else {
//                TextField("Enter value", text: Binding(
//                    get: { viewState.text },
//                    set: { viewState.onTextChanged($0) }
//                ))
//                .textFieldStyle(.roundedBorder)
//                .focused($isFocused)
//                .onChange(of: isFocused) { focused in
//                    viewState.onFocusChanged(focused)
//                }
//            }
//
//            if viewState.showError {
//                Text("Invalid input")
//                    .font(.caption)
//                    .foregroundColor(.red)
//            }
//        }
//    }
//}

// MARK: - ExampleViewModel

@MainActor
final class ExampleViewModel: ObservableObject {
    @Published private(set) var viewState: ViewState

    private var model: Model {
        didSet {
            createViewState()
        }
    }

    init() {
        self.model = Model()
        self.viewState = .initial
        createViewState()
    }

    private func createViewState() {
        let fieldAViewState = createTextInputViewState(
            for: \Model.textFieldA,
            label: "Name",
            validatorCondition: { !$0.isEmpty }
        )
        
        let fieldBViewState = createTextInputViewState(
            for: \Model.textFieldB,
            label: "Confurm Name",
            validatorCondition: { !$0.isEmpty && $0 == self.model.textFieldA.text }
        )
        
        let fieldCViewState = createTextInputViewState(
            for: \Model.textFieldC,
            label: "Password",
            isSecure: true
        )

        self.viewState = ViewState(
            title: makeTitle(),
            statusMessage: makeStatusMessage(),
            fieldAViewState: fieldAViewState,
            fieldBViewState: fieldBViewState,
            fieldCViewState: fieldCViewState
        )
    }

    private func makeTitle() -> String {
        "Example Form"
    }

    private func makeStatusMessage() -> String? {
        model.formSubmitted ? "Form submitted!" : nil
    }

    private func createTextInputViewState(
        for keyPath: WritableKeyPath<Model, TextFieldModel>,
        label: String,
        validatorCondition: ((String) -> Bool)? = nil,
        isSecure: Bool = false
    ) -> TextInputComponentViewState {
        let field = model[keyPath: keyPath]
        let validator = validatorCondition ?? field.validator

        let showError: Bool
        switch keyPath {
        case \Model.textFieldA:
            showError = field.touched && !validator(field.text)

        case \Model.textFieldB:
            let isMatching = field.text == model.textFieldA.text
            if field.isFocused {
                showError = false
            } else {
                showError = field.touched && !isMatching
            }

        case \Model.textFieldC:
            showError = field.touched && !validator(field.text)

        default:
            showError = false
        }

        return TextInputComponentViewState(
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

    func submit() {
        guard model.textFieldA.isValid, model.textFieldB.isValid, model.textFieldC.isValid else { return }
        model.formSubmitted = true
    }

    private struct Model {
        var textFieldA = TextFieldModel()
        var textFieldB = TextFieldModel()
        var textFieldC = TextFieldModel()
        var formSubmitted = false
    }

    struct ViewState {
        let title: String
        let statusMessage: String?
        let fieldAViewState: TextInputComponentViewState
        let fieldBViewState: TextInputComponentViewState
        let fieldCViewState: TextInputComponentViewState

        static let initial = ViewState(
            title: "",
            statusMessage: nil,
            fieldAViewState: TextInputComponentViewState(
                label: "",
                text: "",
                isValid: true,
                showError: false,
                isSecure: false,
                onTextChanged: { _ in },
                onFocusChanged: { _ in }
            ),
            fieldBViewState: TextInputComponentViewState(
                label: "",
                text: "",
                isValid: true,
                showError: false,
                isSecure: false,
                onTextChanged: { _ in },
                onFocusChanged: { _ in }
            ),
            fieldCViewState: TextInputComponentViewState(
                label: "",
                text: "",
                isValid: true,
                showError: false,
                isSecure: true,
                onTextChanged: { _ in },
                onFocusChanged: { _ in }
            )
        )
    }
}

// MARK: - ExampleScreen

struct ExampleScreen: View {
    @ObservedObject var viewModel: ExampleViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text(viewModel.viewState.title)
                .font(.title2)

            TextInputComponent(viewState: viewModel.viewState.fieldAViewState)
            TextInputComponent(viewState: viewModel.viewState.fieldBViewState)
            TextInputComponent(viewState: viewModel.viewState.fieldCViewState)

            if let message = viewModel.viewState.statusMessage {
                Text(message).foregroundColor(.green)
            }

            Button("Submit") {
                viewModel.submit()
            }
            .disabled(!viewModel.viewState.fieldAViewState.isValid
                      || !viewModel.viewState.fieldBViewState.isValid
                      || !viewModel.viewState.fieldCViewState.isValid)
        }
        .padding()
        .onTapGesture {
            // dismiss keyboard & remove focus when tapping outside
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

// MARK: - Preview

struct ExampleScreen_Previews: PreviewProvider {
    static var previews: some View {
        ExampleScreen(viewModel: ExampleViewModel())
    }
}
