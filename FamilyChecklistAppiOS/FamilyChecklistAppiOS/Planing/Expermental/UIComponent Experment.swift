////
////  UIComponent Experment.swift
////  FamilyChecklistAppiOS
////
////  Created by Benjamin james cawley on 03/08/2025.
////
//
//import SwiftUICore
//import SwiftUI
//
//// MARK: - TextInputComponentViewState
//
//struct TextInputComponentViewState {
//    let text: String
//    let isValid: Bool
//    let onTextChanged: (String) -> Void
//}
//
//struct TextFieldComponentModel {
//    var text: String = ""
//    
//}
//// MARK: - TextInputComponent
//
//struct TextInputComponent: View {
//    let viewState: TextInputComponentViewState
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            TextField("Enter value", text: Binding(
//                get: { viewState.text },
//                set: { viewState.onTextChanged($0) }
//            ))
//            .textFieldStyle(.roundedBorder)
//
//            if !viewState.isValid {
//                Text("Invalid input")
//                    .font(.caption)
//                    .foregroundColor(.red)
//            }
//        }
//    }
//}
//
//// MARK: - ExampleViewModel
//
//@MainActor
//final class ExampleViewModel: ObservableObject {
//    @Published private(set) var viewState: ViewState
//
//    private var model: Model {
//        didSet {
//            createViewState()
//        }
//    }
//
//    init() {
//        self.model = Model()
//        self.viewState = .initial
//        createViewState()
//    }
//
//    private func createViewState() {
//        let title = makeTitle()
//        let statusMessage = makeStatusMessage()
//        let fieldAViewState = createTextInputViewState(from: model.textFieldA, onTextChanged: handleTextFieldAChanged)
//        let fieldBViewState = createTextInputViewState(from: model.textFieldB, onTextChanged: handleTextFieldBChanged)
//
//        self.viewState = ViewState(
//            title: title,
//            statusMessage: statusMessage,
//            fieldAViewState: fieldAViewState,
//            fieldBViewState: fieldBViewState
//        )
//    }
//
//    private func makeTitle() -> String {
//        "Example Form"
//    }
//
//    private func makeStatusMessage() -> String? {
//        model.formSubmitted ? "Form submitted!" : nil
//    }
//
//    private func createTextInputViewState(from field: TextFieldComponentModel, onTextChanged: @escaping (String) -> Void) -> TextInputComponentViewState {
//        TextInputComponentViewState(
//            text: field.text,
//            isValid: !field.text.isEmpty,
//            onTextChanged: onTextChanged
//        )
//    }
//
//    private func handleTextFieldAChanged(_ newText: String) {
//        model.textFieldA.text = newText
//    }
//
//    private func handleTextFieldBChanged(_ newText: String) {
//        model.textFieldB.text = newText
//    }
//
//    func submit() {
//        guard !model.textFieldA.text.isEmpty, !model.textFieldB.text.isEmpty else { return }
//        model.formSubmitted = true
//    }
//
//    private struct Model {
//        var textFieldA = TextFieldComponentModel()
//        var textFieldB = TextFieldComponentModel()
//        var formSubmitted = false
//    }
//
//    struct ViewState {
//        let title: String
//        let statusMessage: String?
//        let fieldAViewState: TextInputComponentViewState
//        let fieldBViewState: TextInputComponentViewState
//
//        static let initial = ViewState(
//            title: "",
//            statusMessage: nil,
//            fieldAViewState: TextInputComponentViewState(
//                text: "",
//                isValid: true,
//                onTextChanged: { _ in }
//            ),
//            fieldBViewState: TextInputComponentViewState(
//                text: "",
//                isValid: true,
//                onTextChanged: { _ in }
//            )
//        )
//    }
//}
//
//// MARK: - ExampleScreen
//
//struct ExampleScreen: View {
//    @ObservedObject var viewModel: ExampleViewModel
//
//    var body: some View {
//        VStack(spacing: 16) {
//            Text(viewModel.viewState.title)
//                .font(.title2)
//
//            TextInputComponent(viewState: viewModel.viewState.fieldAViewState)
//            TextInputComponent(viewState: viewModel.viewState.fieldBViewState)
//
//            if let message = viewModel.viewState.statusMessage {
//                Text(message).foregroundColor(.green)
//            }
//
//            Button("Submit") {
//                viewModel.submit()
//            }
//            .disabled(!viewModel.viewState.fieldAViewState.isValid || !viewModel.viewState.fieldBViewState.isValid)
//        }
//        .padding()
//    }
//}
//
//// MARK: - Preview
//
//struct ExampleScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        ExampleScreen(viewModel: ExampleViewModel())
//    }
//}
