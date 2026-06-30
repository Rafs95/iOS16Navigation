//
//  FeedImagePostCard.swift
//  iOS16Navigation
//
//  Created by Raf on 30/06/26.
//

import SwiftUI


/// This card has effect of parallax when scrolled
struct FeedImagePostCard: View {
    let post: DemoPost
    let namespace: Namespace.ID
    let viewportHeight: CGFloat
    let onProfile: () -> Void

    private var author: DemoUser? {
        SocialDemoData.user(username: post.authorUsername)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                if let author {
                    Button(action: onProfile) {
                        HStack(spacing: 10) {
                            UserAvatarView(user: author, size: 38)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(author.name)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.primary)

                                Text("@\(author.username) · \(post.timestamp)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }

                Spacer()

                Text(post.category.uppercased())
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
            }

            NavigationLink(value: AppRoute.postDetail(id: post.id, sourceID: post.id)) {
                ZStack {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(Color(.tertiarySystemFill))

                    GeometryReader { proxy in
                        let imageOffset = parallaxOffset(for: proxy)

                        ZStack(alignment: .bottomLeading) {
                            RemotePostImageView(post: post, context: .feedCard)
                                .frame(height: 500, alignment: .center)
                                .frame(maxWidth: .infinity)
                                .offset(y: imageOffset)
                                .frame(height: proxy.size.height)

                            LinearGradient(
                                colors: [.clear, .black.opacity(0.55)],
                                startPoint: .center,
                                endPoint: .bottom
                            )

                            VStack(alignment: .leading, spacing: 8) {
                                Text(post.title)
                                    .font(.title2.weight(.bold))
                                    .foregroundStyle(.white)
                                    .lineLimit(2)

                                HStack(spacing: 10) {
                                    Label("\(post.likes)", systemImage: "heart.fill")
                                    Label("\(post.commentCount)", systemImage: "message.fill")
                                    Text(post.readTime)
                                }
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.white.opacity(0.88))
                            }
                            .padding(20)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .frame(height: 440)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .matchedTransitionSource(id: post.id, in: namespace)
            }
            .buttonStyle(.plain)

            Text(post.summary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private func parallaxOffset(for proxy: GeometryProxy) -> CGFloat {
        let frame = proxy.frame(in: .global)
        let cardCenterY = frame.midY
        let viewportCenterY = viewportHeight / 2
        let normalizedDistance = (cardCenterY - viewportCenterY) / viewportHeight
        let multipliedDistance = normalizedDistance * 50
        return max(-20, min(20, multipliedDistance))
    }
}
