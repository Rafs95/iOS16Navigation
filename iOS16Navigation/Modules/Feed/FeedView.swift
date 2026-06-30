import SwiftUI
import Nuke

struct FeedView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    let postTransitionNamespace: Namespace.ID

    private let posts = SocialDemoData.posts
    @State private var prefetcher = NukeSupport.makePrefetcher()

    var body: some View {
        GeometryReader { viewport in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Feed")
                            .font(.largeTitle.weight(.bold))

                        Text("A more image-first social timeline with immersive post detail transitions.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    ForEach(posts) { post in
                        FeedImagePostCard(
                            post: post,
                            namespace: postTransitionNamespace,
                            viewportHeight: viewport.size.height,
                            onProfile: { coordinator.openProfile(username: post.authorUsername) }
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            .background(Color(.systemGroupedBackground))
            .onAppear {
                prefetcher.startPrefetching(with: NukeSupport.prefetchRequests(for: posts, context: .feedCard))
            }
            .onDisappear {
                prefetcher.stopPrefetching()
            }
        }
    }
}
