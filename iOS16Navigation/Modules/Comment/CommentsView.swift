import SwiftUI

struct CommentsView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    let postID: String

    private var post: DemoPost? {
        SocialDemoData.post(id: postID)
    }

    private var comments: [DemoComment] {
        SocialDemoData.comments(for: postID)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let post {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(post.title)
                            .font(.title2.weight(.semibold))

                        Text("\(comments.count) comments on this conversation")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                ForEach(comments) { comment in
                    let author = SocialDemoData.user(username: comment.authorUsername)

                    VStack(alignment: .leading, spacing: 14) {
                        HStack(spacing: 12) {
                            if let author {
                                Button {
                                    coordinator.openProfile(username: author.username)
                                } label: {
                                    UserAvatarView(user: author, size: 38)
                                }
                                .buttonStyle(.plain)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(author.name)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(.primary)

                                    Text("@\(author.username) · \(comment.timestamp)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            Spacer()
                        }

                        Text(comment.body)
                            .font(.body)
                            .foregroundStyle(.primary)
                    }
                    .padding(18)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color(.secondarySystemBackground))
                    )
                }
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
    }
}
