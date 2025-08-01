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
        var viewState = viewModel.viewState
        
        VStack(spacing: 32) {
            // Title stays pinned — smooth transition
            Text(viewState.title)
                .font(.largeTitle)
                .bold()
                .frame(maxHeight: 60) // fixes vertical shift
                .animation(.easeInOut(duration: 0.3), value: viewModel.viewState.title)

            // FORM CONTAINER
            VStack(spacing: 16) {
                TextField("Username", text: Binding(
                    get: { viewState.username },
                    set: viewState.onUsernameChange
                ))
                .textFieldStyle(.roundedBorder)

                if viewState.isRegistering {
                    TextField("Email", text: Binding(
                        get: { viewState.email },
                        set: viewState.onEmailChange
                    ))
                    .textFieldStyle(.roundedBorder)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }

                SecureField("Password", text: Binding(
                    get: { viewState.password },
                    set: viewState.onPasswordChange
                ))
                .textFieldStyle(.roundedBorder)

                if viewState.isRegistering {
                    SecureField("Confirm Password", text: Binding(
                        get: { viewState.confirmPassword ?? "" },
                        set: viewState.onConfirmPasswordChange
                    ))
                    .textFieldStyle(.roundedBorder)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }

                if let errorMessage = viewState.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }

                Button(viewState.isRegistering ? "Create Account" : "Login") {
                    Task {
                        await viewState.onSubmit?()
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(viewState.onSubmit == nil)
                .visuallyEnabled(viewState.onSubmit != nil) // TODO: build a custom button so that we dont need to call this.

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
