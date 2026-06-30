//
//  LoginView.swift
//  iOS16Navigation
//
//  Created by Raf on 29/06/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                Spacer()

                VStack(spacing: 16) {
                    Image(systemName: "person.2.crop.square.stack.fill")
                        .font(.system(size: 52))
                        .foregroundStyle(.blue)

                    Text("Welcome back")
                        .font(.largeTitle.weight(.bold))

                    Text("Continue into a polished social demo that exercises tabs, push navigation, deep links, and modal surfaces.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                VStack(alignment: .leading, spacing: 18) {
                    HStack(spacing: 14) {
                        UserAvatarView(user: SocialDemoData.currentUser, size: 54)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(SocialDemoData.currentUser.name)
                                .font(.headline)

                            Text("@\(SocialDemoData.currentUser.username)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Text("This sample keeps auth intentionally simple so the navigation architecture stays the focus.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Button("Continue as Maya") {
                        coordinator.enterMainExperience()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                )

                Spacer()

                Text("Demo flow only. No network or real sign-in required.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
        }
    }
}
