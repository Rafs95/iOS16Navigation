//
//  LoadingOverlayView.swift
//  iOS16Navigation
//
//  Created by Raf on 29/06/26.
//

import SwiftUI

struct LoadingOverlayView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.14)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                ProgressView()
                    .controlSize(.large)

                Text("Resolving deep link...")
                    .font(.subheadline.weight(.semibold))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
    }
}
