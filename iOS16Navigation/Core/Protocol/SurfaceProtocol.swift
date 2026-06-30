//
//  SurfaceProtocol.swift
//  iOS16Navigation
//
//  Created by Raf on 29/06/26.
//

import Combine

@MainActor
public protocol SurfaceProtocol: AnyObject {
    associatedtype SurfaceRoute: Hashable

    var sheet: SurfaceRoute? { get set }
    var fullScreen: SurfaceRoute? { get set }
    var bottomSheet: SurfaceRoute? { get set }
    var floating: SurfaceRoute? { get set }

    func presentSheet(_ route: SurfaceRoute)
    func presentFullScreen(_ route: SurfaceRoute)
    func presentBottomSheet(_ route: SurfaceRoute)
    func presentFloating(_ route: SurfaceRoute)

    func dismissSheet()
    func dismissFullScreen()
    func dismissBottomSheet()
    func dismissFloating()
    func dismissAllSurfaces()
}

@MainActor
public final class AppSurface<SurfaceRoute: Hashable>: ObservableObject, SurfaceProtocol {
    @Published public var sheet: SurfaceRoute?
    @Published public var fullScreen: SurfaceRoute?
    @Published public var bottomSheet: SurfaceRoute?
    @Published public var floating: SurfaceRoute?

    public init(
        sheet: SurfaceRoute? = nil,
        fullScreen: SurfaceRoute? = nil,
        bottomSheet: SurfaceRoute? = nil,
        floating: SurfaceRoute? = nil
    ) {
        self.sheet = sheet
        self.fullScreen = fullScreen
        self.bottomSheet = bottomSheet
        self.floating = floating
    }

    public func presentSheet(_ route: SurfaceRoute) {
        sheet = route
    }

    public func presentFullScreen(_ route: SurfaceRoute) {
        fullScreen = route
    }

    public func presentBottomSheet(_ route: SurfaceRoute) {
        bottomSheet = route
    }

    public func presentFloating(_ route: SurfaceRoute) {
        floating = route
    }

    public func dismissSheet() {
        sheet = nil
    }

    public func dismissFullScreen() {
        fullScreen = nil
    }

    public func dismissBottomSheet() {
        bottomSheet = nil
    }

    public func dismissFloating() {
        floating = nil
    }

    public func dismissAllSurfaces() {
        sheet = nil
        fullScreen = nil
        bottomSheet = nil
        floating = nil
    }
}
