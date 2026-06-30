//
//  ProfileView.swift
//  iOS16Navigation
//
//  Created by Raf on 29/06/26.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    let username: String

    private var user: DemoUser? {
        SocialDemoData.user(username: username)
    }

    var body: some View {
        ScrollView {
            if let user {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 18) {
                        HStack(spacing: 16) {
                            UserAvatarView(user: user, size: 80)

                            VStack(alignment: .leading, spacing: 6) {
                                Text(user.name)
                                    .font(.largeTitle.weight(.bold))

                                Text("@\(user.username)")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)

                                Text(user.location)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Text(user.bio)
                            .font(.body)

                        HStack {
                            ForEach(user.interests, id: \.self) { interest in
                                Text(interest)
                                    .font(.caption.weight(.semibold))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 7)
                                    .background(Color.purple.opacity(0.12), in: Capsule())
                            }
                        }
                    }
                    .padding(22)
                    .background(
                        RoundedRectangle(cornerRadius: 26, style: .continuous)
                            .fill(Color(.secondarySystemBackground))
                    )

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Recent posts")
                            .font(.title3.weight(.semibold))

                        ForEach(SocialDemoData.posts(for: user.username)) { post in
                            PostCardView(
                                post: post,
                                onRead: { coordinator.openPost(id: post.id) },
                                onProfile: {},
                                onComments: { coordinator.openComments(for: post.id) }
                            )
                        }
                    }
                }
                .padding(20)
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Profile unavailable")
                        .font(.title2.weight(.semibold))

                    Text("This demo user could not be found in the local sample data.")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}
