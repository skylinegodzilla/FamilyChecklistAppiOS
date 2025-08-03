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
        let viewState = viewModel.viewState

        VStack(spacing: 32) {
            // Title stays pinned — smooth transition
            Text(viewState.title)
                .font(.largeTitle)
                .bold()
                .frame(maxHeight: 60)
                .animation(.easeInOut(duration: 0.3), value: viewState.title)

            VStack(spacing: 16) {
                // MARK: Username
                TextFieldComponent(viewState: viewState.usernameTextFieldViewState)

                // MARK: Email (only in register mode)
                if viewState.isRegistering {
                    TextFieldComponent(viewState: viewState.emailTextFieldViewState)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }

                // MARK: Password
                TextFieldComponent(viewState: viewState.passwordTextFieldViewState)

                // MARK: Confirm Password (only in register mode)
                if viewState.isRegistering {
                    TextFieldComponent(viewState: viewState.confirmPasswordTextFieldViewState)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }

                // MARK: Error Message
                if let errorMessage = viewState.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }

                // MARK: Submit Button
                Button(viewState.isRegistering ? "Create Account" : "Login") {
                    Task {
                        await viewState.onSubmit?()
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(viewState.onSubmit == nil)
                .visuallyEnabled(viewState.onSubmit != nil)

                // MARK: Toggle Login/Register
                Button(viewState.isRegistering ? "Already have an account?" : "Create an account") {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        viewState.onToggleFormMode()
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
            .animation(.easeInOut(duration: 0.3), value: viewState.isRegistering)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    AccessView()
}
