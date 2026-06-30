import SwiftUI
import NukeUI

struct UserAvatarView: View {
    let user: DemoUser
    var size: CGFloat = 44

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text(user.initials)
                .font(.system(size: size * 0.34, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
        }
        .frame(width: size, height: size)
    }
}

struct ScreenHeaderView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.largeTitle.weight(.bold))

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct StatPillView: View {
    let symbol: String
    let label: String

    var body: some View {
        Label(label, systemImage: symbol)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.secondary.opacity(0.12), in: Capsule())
    }
}

struct PostCardView: View {
    let post: DemoPost
    var onRead: () -> Void = {}
    var onProfile: () -> Void = {}
    var onComments: () -> Void = {}

    private var author: DemoUser? {
        SocialDemoData.user(username: post.authorUsername)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(post.category.uppercased())
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.blue)

                Spacer()

                Text(post.timestamp)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text(post.title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)

                Text(post.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }

            HStack(spacing: 12) {
                if let author {
                    Button(action: onProfile) {
                        HStack(spacing: 10) {
                            UserAvatarView(user: author, size: 36)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(author.name)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.primary)

                                Text("@\(author.username)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }

                Spacer()

                StatPillView(symbol: "heart.fill", label: "\(post.likes)")
                StatPillView(symbol: "text.bubble.fill", label: "\(post.commentCount)")
            }

            HStack {
                Button("Read Post", action: onRead)
                    .buttonStyle(.borderedProminent)

                Button("Comments", action: onComments)
                    .buttonStyle(.bordered)

                Spacer()

                Text(post.readTime)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

struct DemoActionCardView: View {
    let title: String
    let detail: String
    let symbol: String
    let tint: Color
    var actionTitle: String
    var action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: symbol)
                .font(.title2.weight(.semibold))
                .foregroundStyle(tint)

            Text(title)
                .font(.headline)

            Text(detail)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button(actionTitle, action: action)
                .buttonStyle(.borderedProminent)
                .tint(tint)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

struct RemotePostImageView: View {
    let post: DemoPost
    var context: PostImageContext = .feedCard

    var body: some View {
        LazyImage(request: NukeSupport.request(for: post, context: context)) { state in
            if let image = state.image {
                image
                    .resizable()
                    .scaledToFill()
            } else if state.error != nil {
                PostImagePlaceholderView(post: post)
                    .overlay(alignment: .bottomLeading) {
                        Label("Image unavailable", systemImage: "photo")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(12)
                    }
            } else {
                PostImagePlaceholderView(post: post)
                    .overlay {
                        ProgressView()
                            .tint(.white)
                    }
            }
        }
    }
}

private struct PostImagePlaceholderView: View {
    let post: DemoPost

    var body: some View {
        LinearGradient(
            colors: [placeholderBaseColor, placeholderBaseColor.opacity(0.75), .black.opacity(0.25)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(alignment: .bottomLeading) {
            VStack(alignment: .leading, spacing: 8) {
                Text(post.category.uppercased())
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.8))

                Text(post.title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
                    .lineLimit(3)
            }
            .padding(16)
        }
    }

    private var placeholderBaseColor: Color {
        switch post.category {
        case "Community":
            .purple

        case "Engineering":
            .blue

        case "Engagement":
            .pink

        case "Growth":
            .orange

        default:
            .indigo
        }
    }
}
