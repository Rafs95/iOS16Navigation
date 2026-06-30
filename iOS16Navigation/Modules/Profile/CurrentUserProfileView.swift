import SwiftUI

struct CurrentUserProfileView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    private let currentUser = SocialDemoData.currentUser

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ScreenHeaderView(
                    title: currentUser.name,
                    subtitle: "Signed-in demo profile with shortcuts into modal surfaces and more navigation."
                )

                VStack(alignment: .leading, spacing: 18) {
                    HStack(spacing: 16) {
                        UserAvatarView(user: currentUser, size: 72)

                        VStack(alignment: .leading, spacing: 6) {
                            Text("@\(currentUser.username)")
                                .font(.headline)

                            Text(currentUser.location)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Text(currentUser.bio)
                        .font(.body)

                    HStack {
                        ForEach(currentUser.interests, id: \.self) { interest in
                            Text(interest)
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 7)
                                .background(Color.blue.opacity(0.12), in: Capsule())
                        }
                    }
                }
                .padding(22)
                .background(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                )

                VStack(alignment: .leading, spacing: 14) {
                    Text("Demo states")
                        .font(.title3.weight(.semibold))

                    DemoActionCardView(
                        title: "Force update sheet",
                        detail: "Presents a standard modal surface for urgent product messaging.",
                        symbol: "arrow.down.app.fill",
                        tint: .indigo,
                        actionTitle: "Present Sheet"
                    ) {
                        coordinator.presentForceUpdate()
                    }

                    DemoActionCardView(
                        title: "Session expired full screen",
                        detail: "Shows a high-priority blocking state and lets the app safely return to login.",
                        symbol: "lock.shield.fill",
                        tint: .red,
                        actionTitle: "Present Full Screen"
                    ) {
                        coordinator.presentSessionExpired()
                    }

                    DemoActionCardView(
                        title: "Return to login",
                        detail: "Resets the app to the login root so the root-switching flow stays easy to test.",
                        symbol: "arrow.uturn.backward.circle.fill",
                        tint: .gray,
                        actionTitle: "Reset App"
                    ) {
                        coordinator.returnToLogin()
                    }
                }

                VStack(alignment: .leading, spacing: 14) {
                    Text("Recent posts")
                        .font(.title3.weight(.semibold))

                    ForEach(SocialDemoData.posts(for: currentUser.username)) { post in
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
        }
        .background(Color(.systemGroupedBackground))
    }
}
