//
//  iOS16NavigationTests.swift
//  iOS16NavigationTests
//
//  Created by Raf on 29/06/26.
//

import Foundation
import Testing
@testable import iOS16Navigation

struct iOS16NavigationTests {

    @MainActor
    @Test func postDeepLinkResolvesToPostDestination() async throws {
        let handler = AppLinkHandler()
        let destination = try await handler.resolve(url: URL(string: "https://www.example.com/post/post-swiftui-loading")!)

        #expect(destination == .post(id: "post-swiftui-loading"))
    }

    @MainActor
    @Test func commentsDeepLinkResolvesToCommentsDestination() async throws {
        let handler = AppLinkHandler()
        let destination = try await handler.resolve(url: URL(string: "https://www.example.com/comments/post-comment-prompts")!)

        #expect(destination == .comments(postID: "post-comment-prompts"))
    }

    @MainActor
    @Test func unsupportedDeepLinkReturnsUnsupportedError() async {
        let handler = AppLinkHandler()
        let url = URL(string: "https://www.example.com/unknown/demo")!

        var capturedError: LinkHandlerError?

        do {
            _ = try await handler.resolve(url: url)
        } catch let error as LinkHandlerError {
            capturedError = error
        } catch {
            capturedError = nil
        }

        #expect(capturedError == .unsupportedURL)
    }

    @MainActor
    @Test func coordinatorAppliesCommentsDestinationToMainStack() {
        let navigation = AppNavigation<AppRoute, AppRoot>(root: .splash)
        let surface = AppSurface<AppSurfaceRoute>()
        let coordinator = AppCoordinator(
            navigation: navigation,
            surface: surface,
            linkHandler: AppLinkHandler()
        )

        coordinator.apply(.comments(postID: "post-comment-prompts"))

        #expect(navigation.root == .main)
        #expect(navigation.path == [
            .postDetail(id: "post-comment-prompts"),
            .comments(postID: "post-comment-prompts")
        ])
    }

    @MainActor
    @Test func coordinatorRejectsUnknownDestinations() {
        let navigation = AppNavigation<AppRoute, AppRoot>(root: .splash)
        let surface = AppSurface<AppSurfaceRoute>()
        let coordinator = AppCoordinator(
            navigation: navigation,
            surface: surface,
            linkHandler: AppLinkHandler()
        )

        #expect(coordinator.canDisplay(.post(id: "missing-post")) == false)
        #expect(coordinator.canDisplay(.profile(username: "missing-user")) == false)
    }

    @MainActor
    @Test func customSchemePostDeepLinkResolvesToPostDestination() async throws {
        let handler = AppLinkHandler()
        let destination = try await handler.resolve(url: URL(string: "com.arafs.iOS16Navigation://post/post-swiftui-loading")!)

        #expect(destination == .post(id: "post-swiftui-loading"))
    }

    @MainActor
    @Test func customSchemeCommentsDeepLinkResolvesToCommentsDestination() async throws {
        let handler = AppLinkHandler()
        let destination = try await handler.resolve(url: URL(string: "com.arafs.iOS16Navigation://comments/post-comment-prompts")!)

        #expect(destination == .comments(postID: "post-comment-prompts"))
    }

}
