import Foundation

public final class ProfileLinkHandler: BaseLinkHandler<AppLinkDestination> {
    public override var identifier: LinkHandlerIdentifier {
        LinkHandlerIdentifier(host: "www.example.com", pathPrefix: ["profile"])
    }

    public override func resolve(url: URL) async throws -> AppLinkDestination {
        let components = url.pathComponents.filter { $0 != "/" }

        guard components.count == 2 else {
            throw LinkHandlerError.invalidURL
        }

        return .profile(username: components[1])
    }
}
