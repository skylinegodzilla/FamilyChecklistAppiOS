//
//  ButtonStyles.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin James Cawley on 01/08/2025.
//

import SwiftUI

// MARK: - Button Styles

private let cornerRadius: CGFloat = 8

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let shadowRadius: CGFloat = configuration.isPressed ? 0 : 2
        let shadowOpacity: Double = configuration.isPressed ? 0 : 0.7
        let shadowOffset: CGFloat = configuration.isPressed ? 0 : 4

        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(
                        (configuration.isPressed ? Color("ButtonPrimaryHighlight") : Color("ButtonPrimary"))
                            .shadow(.inner(color: Color.black.opacity(shadowOpacity), radius: shadowRadius, x: shadowOffset, y: shadowOffset))
                    )
            )
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let shadowRadius: CGFloat = configuration.isPressed ? 0 : 2
        let shadowOpacity: Double = configuration.isPressed ? 0 : 0.7
        let shadowOffset: CGFloat = configuration.isPressed ? 0 : 4

        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(
                        (configuration.isPressed ? Color("ButtonSecondaryHighlight") : Color("ButtonSecondary"))
                            .shadow(.inner(color: Color.black.opacity(shadowOpacity), radius: shadowRadius, x: shadowOffset, y: shadowOffset))
                    )
            )
    }
}

struct DestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let shadowRadius: CGFloat = configuration.isPressed ? 0 : 2
        let shadowOpacity: Double = configuration.isPressed ? 0 : 0.7
        let shadowOffset: CGFloat = configuration.isPressed ? 0 : 4

        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(
                        (configuration.isPressed ? Color("ButtonDangerHighlight") : Color("ButtonDanger"))
                            .shadow(.inner(color: Color.black.opacity(shadowOpacity), radius: shadowRadius, x: shadowOffset, y: shadowOffset))
                    )
            )
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        Button("Primary") {}.buttonStyle(PrimaryButtonStyle())
        Button("Secondary") {}.buttonStyle(SecondaryButtonStyle())
        Button("Danger") {}.buttonStyle(DestructiveButtonStyle())
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
