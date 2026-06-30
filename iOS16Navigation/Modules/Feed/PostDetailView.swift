import SwiftUI

struct PostDetailView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @Environment(\.dismiss) private var dismiss

    let id: String
    let showsCloseButton: Bool

    private var post: DemoPost? {
        SocialDemoData.post(id: id)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            if let post {
                VStack(alignment: .leading, spacing: 24) {
                    RemotePostImageView(post: post, context: .detailHero)
                        .frame(height: 520)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 34, style: .continuous))

                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 12) {
                            if let author = SocialDemoData.user(username: post.authorUsername) {
                                Button {
                                    coordinator.openProfile(username: author.username)
                                } label: {
                                    HStack(spacing: 12) {
                                        UserAvatarView(user: author, size: 44)

                                        VStack(alignment: .leading, spacing: 3) {
                                            Text(author.name)
                                                .font(.headline)
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

                        Text(post.title)
                            .font(.largeTitle.weight(.bold))

                        Text(post.body)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .lineSpacing(7)

                        HStack {
                            StatPillView(symbol: "heart.fill", label: "\(post.likes) likes")
                            StatPillView(symbol: "text.bubble.fill", label: "\(post.commentCount) comments")
                            StatPillView(symbol: "clock.fill", label: post.readTime)
                        }

                        HStack(spacing: 12) {
                            Button("View Comments") {
                                coordinator.openComments(for: post.id)
                            }
                            .buttonStyle(.borderedProminent)

                            if let author = SocialDemoData.user(username: post.authorUsername) {
                                Button("Visit @\(author.username)") {
                                    coordinator.openProfile(username: author.username)
                                }
                                .buttonStyle(.bordered)
                            }
                        }

                        if !SocialDemoData.relatedPosts(for: post.id).isEmpty {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("More from the feed")
                                    .font(.title3.weight(.semibold))

                                ForEach(SocialDemoData.relatedPosts(for: post.id)) { relatedPost in
                                    Button {
                                        coordinator.openPost(id: relatedPost.id)
                                    } label: {
                                        HStack(spacing: 14) {
                                            RemotePostImageView(post: relatedPost, context: .thumbnail)
                                                .frame(width: 88, height: 88)
                                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                                            VStack(alignment: .leading, spacing: 6) {
                                                Text(relatedPost.title)
                                                    .font(.headline)
                                                    .foregroundStyle(.primary)
                                                    .lineLimit(2)

                                                Text(relatedPost.summary)
                                                    .font(.subheadline)
                                                    .foregroundStyle(.secondary)
                                                    .lineLimit(2)
                                            }

                                            Spacer()
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Post unavailable")
                        .font(.title2.weight(.semibold))

                    Text("This sample post could not be found in the local demo data.")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
            }
        }
        .background(Color(.systemBackground))
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(showsCloseButton)
        .toolbar {
            if showsCloseButton {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.primary)
                            .frame(width: 34, height: 34)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                }
            }
        }
    }
}
