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

// TODO: Build a full custom button so that We can fetch the disabled state from @Environment(\.isEnabled) and do more custom things and keep things DRY
/*
 Why cant we just fetch the value from @Enviroment with a custom style?
 If you try to use @Environment(\.isEnabled) inside your ButtonStyle, that value is always true, because SwiftUI injects a new context inside the button style implementation.
 */

// Here is the boiler plate for a custom one
/*
struct CustomButton<Label: View>: View {
    let action: () -> Void
    let label: () -> Label
    let isDisabled: Bool

    var body: some View {
        Button(action: action) {
            label()
        }
        .disabled(isDisabled)
        .buttonStyle(PrimaryButtonStyle())
        .visuallyDisabledIfDisabled()
    }
}
*/

struct VisuallyEnabled: ViewModifier {
    let isEnabled: Bool

    func body(content: Content) -> some View {
        content
            .opacity(isEnabled ? 1.0 : 0.5)
            .grayscale(isEnabled ? 0.0 : 1.0)
            .saturation(isEnabled ? 1.0 : 0.2)
            .allowsHitTesting(isEnabled)
    }
}

extension View { // TODO: Build an view extention file and move this to it.
    func visuallyEnabled(_ isEnabled: Bool) -> some View {
        self.modifier(VisuallyEnabled(isEnabled: isEnabled))
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        Button("Primary") {}.buttonStyle(PrimaryButtonStyle())
        Button("Secondary") {}.buttonStyle(SecondaryButtonStyle())
        Button("Danger") {}.buttonStyle(DestructiveButtonStyle())
        Button("Disabled") {}.buttonStyle(PrimaryButtonStyle()).disabled(true).visuallyEnabled(false)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
