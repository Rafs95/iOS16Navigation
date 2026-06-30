import Foundation
import Nuke

enum PostImageContext {
    case feedCard
    case detailHero
    case thumbnail

    var requestSize: CGSize {
        switch self {
        case .feedCard:
            CGSize(width: 900, height: 1200)

        case .detailHero:
            CGSize(width: 1200, height: 1600)

        case .thumbnail:
            CGSize(width: 176, height: 176)
        }
    }
}

enum NukeSupport {
    static func configureSharedPipelineIfNeeded() {
        ImagePipeline.shared = ImagePipeline {
            $0.isProgressiveDecodingEnabled = true
        }
    }

    static func request(for post: DemoPost, context: PostImageContext) -> ImageRequest? {
        guard let url = post.imageURL else {
            return nil
        }

        return ImageRequest(
            url: url,
            processors: [
                .resize(size: context.requestSize, unit: .points, contentMode: .aspectFill, crop: true)
            ]
        )
    }

    static func prefetchRequests(for posts: [DemoPost], context: PostImageContext) -> [ImageRequest] {
        posts.compactMap { request(for: $0, context: context) }
    }

    static func makePrefetcher() -> ImagePrefetcher {
        ImagePrefetcher(destination: .diskCache)
    }
}
