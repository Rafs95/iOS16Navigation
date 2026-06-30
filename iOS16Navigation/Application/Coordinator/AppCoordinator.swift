//
//  AppCoordinator.swift
//  iOS16Navigation
//
//  Created by Raf on 29/06/26.
//

import Foundation
import Combine
import SwiftUI
import UIKit

private let rootTransitionAnimation = Animation.spring(response: 0.52, dampingFraction: 0.9)

enum AppRoot: Hashable {
    case splash
    case login
    case main
}

enum AppRoute: Hashable {
    case postDetail(id: String, sourceID: String? = nil)
    case comments(postID: String)
    case profile(username: String)
}

enum AppSurfaceRoute: Hashable {
    case loading
    case error
    case forceUpdate
    case sessionExpired
}

@MainActor
final class AppCoordinator: ObservableObject, CoordinatorProtocol {
    let navigation: AppNavigation<AppRoute, AppRoot>
    let surface: AppSurface<AppSurfaceRoute>

    private let linkHandler: AppLinkHandler

    init(
        navigation: AppNavigation<AppRoute, AppRoot>,
        surface: AppSurface<AppSurfaceRoute>,
        linkHandler: AppLinkHandler
    ) {
        self.navigation = navigation
        self.surface = surface
        self.linkHandler = linkHandler
    }

    func start() {
        withAnimation(rootTransitionAnimation) {
            navigation.setRoot(.splash)
            navigation.popToRoot()
            surface.dismissAllSurfaces()
        }
    }

    func reset() {
        withAnimation(rootTransitionAnimation) {
            navigation.setRoot(.splash)
            navigation.popToRoot()
            surface.dismissAllSurfaces()
        }
    }

    func showLogin() {
        withAnimation(rootTransitionAnimation) {
            navigation.setRoot(.login)
            navigation.popToRoot()
            surface.dismissAllSurfaces()
        }
    }

    func enterMainExperience() {
        withAnimation(rootTransitionAnimation) {
            navigation.setRoot(.main)
            navigation.popToRoot()
            surface.dismissAllSurfaces()
        }
    }

    func openPost(id: String) {
        navigation.push(.postDetail(id: id, sourceID: nil))
    }

    func openComments(for postID: String) {
        navigation.push(.comments(postID: postID))
    }

    func openProfile(username: String) {
        navigation.push(.profile(username: username))
    }

    func presentForceUpdate() {
        surface.presentSheet(.forceUpdate)
    }

    func presentSessionExpired() {
        surface.presentFullScreen(.sessionExpired)
    }

    func dismissSheet() {
        surface.dismissSheet()
    }

    func dismissSessionExpired() {
        surface.dismissFullScreen()
    }

    func returnToLogin() {
        withAnimation(rootTransitionAnimation) {
            navigation.setRoot(.login)
            navigation.popToRoot()
            surface.dismissAllSurfaces()
        }
    }

    @discardableResult
    func open(url: URL) -> Bool {
        Task {
            await handle(url: url)
        }

        return true
    }

    private func handle(url: URL) async {
        surface.presentFloating(.loading)

        do {
            try await Task.sleep(for: .milliseconds(700))
            let destination = try await linkHandler.resolve(url: url)

            guard canDisplay(destination) else {
                throw LinkHandlerError.invalidURL
            }

            surface.dismissFloating()
            apply(destination)
        } catch {
            surface.dismissFloating()
            surface.presentSheet(.error)
        }
    }

    func canDisplay(_ destination: AppLinkDestination) -> Bool {
        switch destination {
        case .post(let id), .comments(let id):
            SocialDemoData.post(id: id) != nil

        case .profile(let username):
            SocialDemoData.user(username: username) != nil
        }
    }

    func apply(_ destination: AppLinkDestination) {
        switch destination {
        case .post(let id):
            withAnimation(rootTransitionAnimation) {
                navigation.setRoot(.main)
                navigation.setStack([
                    .postDetail(id: id, sourceID: nil)
                ])
            }

        case .comments(let postID):
            withAnimation(rootTransitionAnimation) {
                navigation.setRoot(.main)
                navigation.setStack([
                    .postDetail(id: postID, sourceID: nil),
                    .comments(postID: postID)
                ])
            }

        case .profile(let username):
            withAnimation(rootTransitionAnimation) {
                navigation.setRoot(.main)
                navigation.setStack([
                    .profile(username: username)
                ])
            }
        }
    }
}
