import SwiftUI

struct ExploreView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    private let creators = SocialDemoData.users.filter { $0.username != SocialDemoData.currentUser.username }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ScreenHeaderView(
                    title: "Explore",
                    subtitle: "Discovery content plus in-app deep-link demos for success, loading, and failure states."
                )

                VStack(alignment: .leading, spacing: 14) {
                    Text("Creators")
                        .font(.title3.weight(.semibold))

                    ForEach(creators) { creator in
                        Button {
                            coordinator.openProfile(username: creator.username)
                        } label: {
                            HStack(spacing: 14) {
                                UserAvatarView(user: creator, size: 46)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(creator.name)
                                        .font(.headline)
                                        .foregroundStyle(.primary)

                                    Text(creator.bio)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.tertiary)
                            }
                            .padding(18)
                            .background(
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .fill(Color(.secondarySystemBackground))
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }

                VStack(alignment: .leading, spacing: 14) {
                    Text("Deep link demos")
                        .font(.title3.weight(.semibold))

                    DemoActionCardView(
                        title: "Open a post from a deep link",
                        detail: "Shows the loading overlay, resolves a valid post URL, and navigates into post detail.",
                        symbol: "link.circle.fill",
                        tint: .blue,
                        actionTitle: "Open Post"
                    ) {
                        openDeepLink("https://www.example.com/post/post-swiftui-loading")
                    }

                    DemoActionCardView(
                        title: "Jump directly to comments",
                        detail: "Resolves to a post and comments stack, demonstrating multi-step navigation from a single link.",
                        symbol: "text.bubble.fill",
                        tint: .purple,
                        actionTitle: "Open Comments"
                    ) {
                        openDeepLink("https://www.example.com/comments/post-comment-prompts")
                    }

                    DemoActionCardView(
                        title: "Open a creator profile",
                        detail: "Routes directly into a profile destination from a supported URL pattern.",
                        symbol: "person.crop.circle.badge.checkmark",
                        tint: .green,
                        actionTitle: "Open Profile"
                    ) {
                        openDeepLink("https://www.example.com/profile/oliver")
                    }

                    DemoActionCardView(
                        title: "Trigger an invalid link",
                        detail: "Shows the error sheet when resolution fails or the URL is unsupported.",
                        symbol: "exclamationmark.triangle.fill",
                        tint: .orange,
                        actionTitle: "Open Invalid Link"
                    ) {
                        openDeepLink("https://www.example.com/unknown/demo")
                    }
                }
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
    }

    private func openDeepLink(_ value: String) {
        guard let url = URL(string: value) else {
            return
        }

        coordinator.open(url: url)
    }
}
