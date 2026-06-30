//
//  SplashView.swift
//  iOS16Navigation
//
//  Created by Raf on 29/06/26.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.85)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.white)

                Text("Pulse")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text("A coordinator-driven social app showcase for iOS 16 navigation.")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.88))
                    .multilineTextAlignment(.center)

                ProgressView()
                    .tint(.white)
                    .padding(.top, 12)
            }
            .padding(32)
        }
        .task {
            try? await Task.sleep(for: .milliseconds(1200))
            coordinator.showLogin()
        }
    }
}
