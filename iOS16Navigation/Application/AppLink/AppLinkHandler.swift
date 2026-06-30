//
//  AppLinkHandler.swift
//  iOS16Navigation
//
//  Created by Raf on 29/06/26.
//

import Foundation

public final class AppLinkHandler {
    private let handlers: [BaseLinkHandler<AppLinkDestination>]

    public init(
        handlers: [BaseLinkHandler<AppLinkDestination>] = [
            CommentsLinkHandler(),
            PostLinkHandler(),
            ProfileLinkHandler()
        ]
    ) {
        self.handlers = handlers
    }

    public func resolve(url: URL) async throws -> AppLinkDestination {
        guard let handler = handlers.first(where: { $0.identifier.matches(url: url) }) else {
            throw LinkHandlerError.unsupportedURL
        }

        return try await handler.resolve(url: url)
    }
}
