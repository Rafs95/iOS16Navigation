//
//  BaseLinkHandler.swift
//  iOS16Navigation
//
//  Created by Raf on 29/06/26.
//

import Foundation

public protocol LinkHandlerProtocol {
    associatedtype Destination

    var identifier: LinkHandlerIdentifier { get }

    func resolve(url: URL) async throws -> Destination
}

open class BaseLinkHandler<Destination>: LinkHandlerProtocol {
    open var identifier: LinkHandlerIdentifier {
        fatalError("Subclasses must override identifier")
    }

    public init() {}

    open func resolve(url: URL) async throws -> Destination {
        throw LinkHandlerError.unsupportedURL
    }
}
