//
//  AccessView.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 01/08/2025.
//

import SwiftUI

struct AccessView: View {
    @StateObject private var viewModel = AccessViewModel()

    var body: some View {
        VStack(spacing: 32) {
            // Title stays pinned — smooth transition
            Text(viewModel.viewState.title)
                .font(.largeTitle)
                .bold()
                .frame(maxHeight: 60) // fixes vertical shift
                .animation(.easeInOut(duration: 0.3), value: viewModel.viewState.title)

            // FORM CONTAINER
            VStack(spacing: 16) {
                TextField("Username", text: Binding(
                    get: { viewModel.viewState.username },
                    set: viewModel.viewState.onUsernameChange
                ))
                .textFieldStyle(.roundedBorder)

                if viewModel.viewState.isRegistering {
                    TextField("Email", text: Binding(
                        get: { viewModel.viewState.email },
                        set: viewModel.viewState.onEmailChange
                    ))
                    .textFieldStyle(.roundedBorder)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }

                SecureField("Password", text: Binding(
                    get: { viewModel.viewState.password },
                    set: viewModel.viewState.onPasswordChange
                ))
                .textFieldStyle(.roundedBorder)

                if viewModel.viewState.isRegistering {
                    SecureField("Confirm Password", text: Binding(
                        get: { viewModel.viewState.confirmPassword ?? "" },
                        set: viewModel.viewState.onConfirmPasswordChange
                    ))
                    .textFieldStyle(.roundedBorder)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }

                if let errorMessage = viewModel.viewState.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }

                Button(viewModel.viewState.isRegistering ? "Create Account" : "Login") {
                    Task {
                        await viewModel.viewState.onSubmit?()
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(viewModel.viewState.onSubmit == nil)

                Button(viewModel.viewState.isRegistering ? "Already have an account?" : "Create an account") {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        viewModel.viewState.onToggleFormMode()
                    }
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            )
            .animation(.easeInOut(duration: 0.3), value: viewModel.viewState.isRegistering)

            Spacer()
        }
        .padding()
    }
}



#Preview {
    AccessView()
}
