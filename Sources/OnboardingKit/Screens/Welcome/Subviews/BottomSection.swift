//
//  BottomSection.swift
//  
//
//  Created by James Sedlacek on 12/30/23.
//

import SwiftUI

@available(iOS 26.0, macOS 26.0, *) @MainActor
struct BottomSection {
    private let accentColor: Color
    private let appDisplayName: String
    private let continueAction: () -> Void
    private let dataPrivacyAction: () -> Void
    @State private var isAnimating: Bool = false

    init(
        accentColor: Color,
        appDisplayName: String,
        continueAction: @escaping () -> Void,
        dataPrivacyAction: @escaping () -> Void
    ) {
        self.accentColor = accentColor
        self.appDisplayName = appDisplayName
        self.continueAction = continueAction
        self.dataPrivacyAction = dataPrivacyAction
    }

    private func onAppear() {
        Animation.bottomSection.deferred {
            isAnimating = true
        }
    }

    private func disclosureAction() {
        dataPrivacyAction()
    }
}

@available(iOS 26.0, macOS 26.0, *) @MainActor
extension BottomSection: View {
    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            dataPrivacyImage
            disclosureText
            continueButton
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 24)
        .background(.ultraThinMaterial)
        .mask(opacityLinearGradient)
        .opacity(isAnimating ? 1 : 0)
        .onAppear(perform: onAppear)
    }

    private var dataPrivacyImage: some View {
        Image(.dataPrivacy)
            .resizable()
            .foregroundStyle(accentColor)
            .frame(width: 40, height: 40)
    }

    private var disclosureText: some View {
        Group {
            Text(verbatim: appDisplayName)
                .foregroundStyle(.secondary) +
            Text(.privacyDataCollection, bundle: .module)
                .foregroundStyle(.secondary) +
            Text(.privacyDataManagement, bundle: .module)
                .foregroundStyle(accentColor)
                .bold()
        }
        .multilineTextAlignment(.center)
        .font(.caption)
        .padding(.bottom, 24)
        .padding(.top, 6)
        .onTapGesture(perform: disclosureAction)
    }

    private var continueButton: some View {
        Button(
            action: continueAction,
            label: continueText
        )
        .font(.title3.weight(.medium))
        .buttonStyle(.glassProminent)
        .tint(accentColor)
    }

    private func continueText() -> some View {
        Text(.actionContinue, bundle: .module)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
    }

    private func opacityLinearGradient() -> some View {
        LinearGradient(
            colors: [.black.opacity(0.9), .black, .black, .black],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea(edges: .bottom)
    }
}

@available(iOS 26.0, macOS 26.0, *)
#Preview {
    VStack {
        Spacer()
    }
    .safeAreaInset(edge: .bottom) {
        BottomSection(
            accentColor: .blue,
            appDisplayName: .init("Test App"),
            continueAction: {
                print("Continue Tapped")
            },
            dataPrivacyAction: {
                print("Privacy Policy Content")
            }
        )
    }
}
