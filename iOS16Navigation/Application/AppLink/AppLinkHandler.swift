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
        var targetURL = url
        if url.scheme?.lowercased() == "com.arafs.ios16navigation" {
            let hostComponent = url.host ?? ""
            let pathComponent = url.path
            var components = URLComponents()
            components.scheme = "https"
            components.host = "www.example.com"
            components.path = "/" + hostComponent + pathComponent
            components.query = url.query
            if let normalizedURL = components.url {
                targetURL = normalizedURL
            }
        }

        guard let handler = handlers.first(where: { $0.identifier.matches(url: targetURL) }) else {
            throw LinkHandlerError.unsupportedURL
        }

        return try await handler.resolve(url: targetURL)
    }
}
