//
//  LinkHandlerIdentifier.swift
//  iOS16Navigation
//
//  Created by Raf on 29/06/26.
//

import Foundation

public struct LinkHandlerIdentifier: Hashable {
    public let host: String
    public let pathPrefix: [String]

    public init(host: String, pathPrefix: [String]) {
        self.host = host
        self.pathPrefix = pathPrefix
    }

    public func matches(url: URL) -> Bool {
        guard url.host?.lowercased() == host.lowercased() else {
            return false
        }

        let components = url.pathComponents
            .filter { $0 != "/" }

        guard components.count >= pathPrefix.count else {
            return false
        }

        return Array(components.prefix(pathPrefix.count)) == pathPrefix
    }
}
