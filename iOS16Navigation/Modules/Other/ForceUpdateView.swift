//
//  ForceUpdateView.swift
//  iOS16Navigation
//
//  Created by Raf on 29/06/26.
//

import SwiftUI

struct ForceUpdateView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(systemName: "arrow.down.app.fill")
                .font(.system(size: 42))
                .foregroundStyle(.indigo)

            Text("Update available")
                .font(.title2.weight(.bold))

            Text("Use this sheet to demonstrate high-visibility but non-blocking product messaging. In a production app, this could be tied to version policy or release gates.")
                .font(.body)
                .foregroundStyle(.secondary)

            HStack {
                Button("Later") {
                    coordinator.dismissSheet()
                }
                .buttonStyle(.bordered)

                Button("View Update") {
                    coordinator.dismissSheet()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(28)
        .presentationDetents([.height(340)])
        .presentationDragIndicator(.visible)
    }
}
