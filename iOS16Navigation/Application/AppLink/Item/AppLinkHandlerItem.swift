//
//  AppLinkHandlerItem.swift
//  iOS16Navigation
//
//  Created by Raf on 29/06/26.
//

import Foundation

public final class AppLinkHandlerItem: BaseLinkHandler<AppLinkDestination> {
    private let itemIdentifier: LinkHandlerIdentifier
    public override var identifier: LinkHandlerIdentifier {
        itemIdentifier
    }

    private let handler: (URL) async throws -> AppLinkDestination

    public init(
        identifier: LinkHandlerIdentifier,
        handler: @escaping (URL) async throws -> AppLinkDestination
    ) {
        self.itemIdentifier = identifier
        self.handler = handler
        super.init()
    }

    public override func resolve(url: URL) async throws -> AppLinkDestination {
        try await handler(url)
    }
}
