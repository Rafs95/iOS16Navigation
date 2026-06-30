//
//  ErrorView.swift
//  iOS16Navigation
//
//  Created by Raf on 29/06/26.
//

import SwiftUI

struct ErrorView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 44))
                .foregroundStyle(.orange)

            Text("Link unavailable")
                .font(.title2.weight(.bold))

            Text("The demo link could not be resolved. Try one of the supported post, comments, or profile links from Explore.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Dismiss") {
                coordinator.dismissSheet()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxHeight: .infinity)
        .padding(28)
        .presentationDetents([.height(280)])
        .presentationDragIndicator(.visible)
    }
}
