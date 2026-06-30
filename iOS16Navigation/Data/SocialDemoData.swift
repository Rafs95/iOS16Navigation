import Foundation

struct DemoUser: Identifiable, Hashable {
    let id: String
    let username: String
    let name: String
    let bio: String
    let location: String
    let interests: [String]

    var initials: String {
        name
            .split(separator: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map(String.init)
            .joined()
    }
}

struct DemoPost: Identifiable, Hashable {
    let id: String
    let authorUsername: String
    let title: String
    let summary: String
    let body: String
    let likes: Int
    let commentCount: Int
    let category: String
    let readTime: String
    let timestamp: String

    var imageURL: URL? {
        URL(string: "https://picsum.photos/seed/\(id)/900/1200")
    }
}

struct DemoComment: Identifiable, Hashable {
    let id: String
    let postID: String
    let authorUsername: String
    let body: String
    let timestamp: String
}

enum SocialDemoData {
    static let currentUserUsername = "maya"

    static let users: [DemoUser] = [
        DemoUser(
            id: "user-maya",
            username: "maya",
            name: "Maya Chen",
            bio: "Product designer documenting how small UX choices change social behavior.",
            location: "Singapore",
            interests: ["Design", "Research", "Communities"]
        ),
        DemoUser(
            id: "user-oliver",
            username: "oliver",
            name: "Oliver Grant",
            bio: "iOS engineer sharing build notes, shipping lessons, and performance wins.",
            location: "Melbourne",
            interests: ["SwiftUI", "Performance", "Tooling"]
        ),
        DemoUser(
            id: "user-sam",
            username: "sam",
            name: "Sam Rivera",
            bio: "Writes about creator tools, product launches, and growth loops.",
            location: "Austin",
            interests: ["Creators", "Growth", "Startups"]
        ),
        DemoUser(
            id: "user-lina",
            username: "lina",
            name: "Lina Park",
            bio: "Community lead obsessed with onboarding flows that feel human.",
            location: "Seoul",
            interests: ["Onboarding", "Copy", "Retention"]
        )
    ]

    static let posts: [DemoPost] = [
        DemoPost(
            id: "post-launch-cadence",
            authorUsername: "maya",
            title: "The launch cadence that kept our community engaged for 6 weeks",
            summary: "A simple weekly rhythm of previews, recaps, and creator spotlights that kept momentum without burning out the team.",
            body: "We stopped trying to make every post feel like a campaign. Instead, we defined a weekly rhythm: Monday previews, Wednesday maker notes, Friday community highlights. The repeatable structure reduced planning overhead and made the audience expect a steady pulse rather than occasional spikes. What mattered most was consistency and the way each post invited a lightweight response.",
            likes: 184,
            commentCount: 18,
            category: "Community",
            readTime: "4 min read",
            timestamp: "2h ago"
        ),
        DemoPost(
            id: "post-swiftui-loading",
            authorUsername: "oliver",
            title: "A cleaner loading pattern for coordinator-driven SwiftUI apps",
            summary: "When deep links arrive mid-flow, a lightweight overlay keeps the transition legible without fighting navigation state.",
            body: "The mistake I used to make was treating loading as a separate screen. In navigation-heavy apps, that often creates more state transitions than the underlying work itself. A floating overlay works better for brief actions like link resolution because the user keeps their context while still getting feedback that something is happening.",
            likes: 231,
            commentCount: 12,
            category: "Engineering",
            readTime: "3 min read",
            timestamp: "5h ago"
        ),
        DemoPost(
            id: "post-comment-prompts",
            authorUsername: "lina",
            title: "The question prompts that doubled first-time comments",
            summary: "Open-ended asks underperformed clear prompts with a specific angle and low effort required to respond.",
            body: "We replaced generic calls to action like 'What do you think?' with pointed prompts such as 'Which part would you try first?' or 'What would you remove from this flow?' The difference was immediate. People participate more when the response shape is obvious and the effort feels bounded.",
            likes: 147,
            commentCount: 24,
            category: "Engagement",
            readTime: "5 min read",
            timestamp: "Yesterday"
        ),
        DemoPost(
            id: "post-discovery-loop",
            authorUsername: "sam",
            title: "A small discovery loop that made every profile page more useful",
            summary: "We linked posts, profiles, and comment threads in tighter loops so curiosity had somewhere obvious to go.",
            body: "The strongest profiles did not just summarize who someone was. They gave visitors a next step: a post to read, a thread to join, or a creator to compare. Good discovery is less about recommendation engines and more about making the next interaction feel inevitable.",
            likes: 96,
            commentCount: 9,
            category: "Growth",
            readTime: "4 min read",
            timestamp: "Yesterday"
        ),
        DemoPost(
            id: "post-feed-density",
            authorUsername: "maya",
            title: "Why feed density matters more than another card style refresh",
            summary: "Spacing, grouping, and quick-scan metadata changed perceived quality more than visual decoration did.",
            body: "Teams often chase polish through visual novelty, but the bigger win is usually information density. When a user can scan title, author, social proof, and next actions in one glance, the feed feels smart. If they need to parse every card from scratch, it feels tiring even if it is pretty.",
            likes: 203,
            commentCount: 15,
            category: "Design",
            readTime: "3 min read",
            timestamp: "2d ago"
        )
    ]

    static let comments: [DemoComment] = [
        DemoComment(id: "comment-1", postID: "post-launch-cadence", authorUsername: "sam", body: "The weekly rhythm point is great. Did you also keep the visual template the same each week?", timestamp: "1h ago"),
        DemoComment(id: "comment-2", postID: "post-launch-cadence", authorUsername: "lina", body: "This lines up with what we saw in onboarding email series too. Predictability increased replies.", timestamp: "45m ago"),
        DemoComment(id: "comment-3", postID: "post-swiftui-loading", authorUsername: "maya", body: "Using an overlay instead of a loading route made the transition feel a lot calmer in our app as well.", timestamp: "3h ago"),
        DemoComment(id: "comment-4", postID: "post-swiftui-loading", authorUsername: "sam", body: "I like that this keeps deep-link resolution from polluting the stack with temporary states.", timestamp: "2h ago"),
        DemoComment(id: "comment-5", postID: "post-comment-prompts", authorUsername: "maya", body: "Specific prompts also make moderation easier because the replies have more structure.", timestamp: "20h ago"),
        DemoComment(id: "comment-6", postID: "post-comment-prompts", authorUsername: "oliver", body: "Would love to see examples of the prompt copy that performed best.", timestamp: "18h ago"),
        DemoComment(id: "comment-7", postID: "post-discovery-loop", authorUsername: "lina", body: "Yes. Discovery often feels like layout design wearing a product strategy hat.", timestamp: "1d ago"),
        DemoComment(id: "comment-8", postID: "post-feed-density", authorUsername: "oliver", body: "Strongly agree. The biggest win is often reducing the amount of visual decoding work.", timestamp: "2d ago")
    ]

    static var currentUser: DemoUser {
        user(username: currentUserUsername) ?? users[0]
    }

    static var featuredPosts: [DemoPost] {
        Array(posts.prefix(2))
    }

    static func user(username: String) -> DemoUser? {
        users.first { $0.username == username }
    }

    static func post(id: String) -> DemoPost? {
        posts.first { $0.id == id }
    }

    static func posts(for username: String) -> [DemoPost] {
        posts.filter { $0.authorUsername == username }
    }

    static func comments(for postID: String) -> [DemoComment] {
        comments.filter { $0.postID == postID }
    }

    static func relatedPosts(for postID: String) -> [DemoPost] {
        guard let referencePost = post(id: postID) else {
            return []
        }

        return posts.filter {
            $0.id != postID && ($0.category == referencePost.category || $0.authorUsername == referencePost.authorUsername)
        }
    }
}
