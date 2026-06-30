//
//  SessionExpiredView.swift
//  iOS16Navigation
//
//  Created by Raf on 29/06/26.
//

import SwiftUI

struct SessionExpiredView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.red.opacity(0.9), Color.orange.opacity(0.85)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 22) {
                Image(systemName: "lock.trianglebadge.exclamationmark.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(.white)

                Text("Session expired")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)

                Text("This full-screen route demonstrates a blocking recovery state. Returning to login resets the app flow cleanly.")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.88))
                    .multilineTextAlignment(.center)

                Button("Return to Login") {
                    coordinator.returnToLogin()
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .foregroundStyle(.red)
            }
            .padding(32)
        }
    }
}
