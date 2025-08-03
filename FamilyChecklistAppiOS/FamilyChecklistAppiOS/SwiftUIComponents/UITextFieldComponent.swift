//
//  UITextFieldComponent.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 03/08/2025.
//

import SwiftUICore
import SwiftUI

// MARK: - TextInputComponentViewState

struct TextInputComponentViewState {
    let label: String
    let text: String
    let isValid: Bool
    let showError: Bool
    let isSecure: Bool
    let onTextChanged: (String) -> Void
    let onFocusChanged: (Bool) -> Void
}

// MARK: - TextInputComponentModel

struct TextFieldModel {
    var text: String = ""
    var touched: Bool = false
    var isFocused: Bool = false

    let validator: (String) -> Bool

    init(text: String = "", validator: @escaping (String) -> Bool = { _ in true }) {
        self.text = text
        self.validator = validator
    }

    mutating func updateText(_ newText: String) {
        self.text = newText
    }

    mutating func setTouched() {
        self.touched = true
    }

    mutating func setFocus(_ focused: Bool) {
        self.isFocused = focused
        if !focused {
            setTouched()
        }
    }

    var isValid: Bool {
        validator(text)
    }
}

// MARK: - TextInputComponent

struct TextInputComponent: View {
    let viewState: TextInputComponentViewState
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewState.label)
                .font(.caption)
                .foregroundColor(.secondary)

            if viewState.isSecure {
                SecureField("Enter value", text: Binding(
                    get: { viewState.text },
                    set: { viewState.onTextChanged($0) }
                ))
                .textFieldStyle(.roundedBorder)
                .focused($isFocused)
                .onChange(of: isFocused) { focused in
                    viewState.onFocusChanged(focused)
                }
            } else {
                TextField("Enter value", text: Binding(
                    get: { viewState.text },
                    set: { viewState.onTextChanged($0) }
                ))
                .textFieldStyle(.roundedBorder)
                .focused($isFocused)
                .onChange(of: isFocused) { focused in
                    viewState.onFocusChanged(focused)
                }
            }

            if viewState.showError {
                Text("Invalid input")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

// MARK: - Preview
// this is a complex preview because we are doing this with out a view model

struct TextInputComponent_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
            .padding()
            .previewLayout(.sizeThatFits)
    }

    struct PreviewWrapper: View {
        @State private var textA = ""
        @State private var textB = ""
        @State private var textC = ""

        @State private var focusedField: String? = nil
        @State private var touchedA = false
        @State private var touchedB = false
        @State private var touchedC = false

        var body: some View {
            VStack(spacing: 16) {
                TextInputComponent(viewState: makeViewState(
                    id: "A",
                    label: "Username",
                    text: textA,
                    isSecure: false,
                    validator: { !$0.isEmpty },
                    onTextChanged: { textA = $0 }
                ))

                TextInputComponent(viewState: makeViewState(
                    id: "B",
                    label: "Email",
                    text: textB,
                    isSecure: false,
                    validator: { $0.contains("@") && $0.contains(".") },
                    onTextChanged: { textB = $0 }
                ))

                TextInputComponent(viewState: makeViewState(
                    id: "C",
                    label: "Password",
                    text: textC,
                    isSecure: true,
                    validator: { $0.count >= 8 },
                    onTextChanged: { textC = $0 }
                ))
            }
        }

        private func makeViewState(
            id: String,
            label: String,
            text: String,
            isSecure: Bool,
            validator: @escaping (String) -> Bool,
            onTextChanged: @escaping (String) -> Void
        ) -> TextInputComponentViewState {
            let isFocused = focusedField == id
            let touched: Bool
            switch id {
            case "A": touched = touchedA
            case "B": touched = touchedB
            case "C": touched = touchedC
            default: touched = false
            }

            return TextInputComponentViewState(
                label: label,
                text: text,
                isValid: validator(text),
                showError: touched && !validator(text),
                isSecure: isSecure,
                onTextChanged: onTextChanged,
                onFocusChanged: { newFocus in
                    focusedField = newFocus ? id : nil
                    if !newFocus {
                        switch id {
                        case "A": touchedA = true
                        case "B": touchedB = true
                        case "C": touchedC = true
                        default: break
                        }
                    }
                }
            )
        }
    }
}

