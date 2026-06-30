//
//  ContentView.swift
//  iOS16Navigation
//
//  Created by Raf on 29/06/26.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator: AppCoordinator
    @State private var previousRoot: AppRoot = .splash
    @Namespace private var feedPostTransitionNamespace

    @ObservedObject private var navigation: AppNavigation<AppRoute, AppRoot>
    @ObservedObject private var surface: AppSurface<AppSurfaceRoute>

    @MainActor
    init() {
        let navigation = AppNavigation<AppRoute, AppRoot>(
            path: [],
            root: .splash
        )

        let surface = AppSurface<AppSurfaceRoute>()

        let coordinator = AppCoordinator(
            navigation: navigation,
            surface: surface,
            linkHandler: AppLinkHandler()
        )

        _coordinator = StateObject(wrappedValue: coordinator)
        _navigation = ObservedObject(wrappedValue: navigation)
        _surface = ObservedObject(wrappedValue: surface)
    }

    var body: some View {
        rootView
            .environmentObject(coordinator)
            .onChange(of: navigation.root) { oldValue, _ in
                previousRoot = oldValue
            }
            .onOpenURL { url in
                coordinator.open(url: url)
            }
            .sheet(isPresented: sheetBinding) {
                if let route = surface.sheet {
                    sheetView(for: route)
                }
            }
            .fullScreenCover(isPresented: fullScreenBinding) {
                if let route = surface.fullScreen {
                    fullScreenView(for: route)
                }
            }
            .sheet(isPresented: bottomSheetBinding) {
                if let route = surface.bottomSheet {
                    bottomSheetView(for: route)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
            }
            .overlay {
                if let route = surface.floating {
                    floatingView(for: route)
                }
            }
    }

    @ViewBuilder
    private var rootView: some View {
        ZStack {
            switch navigation.root {
            case .splash:
                SplashView()
                    .environmentObject(coordinator)
                    .transition(rootTransition)

            case .login:
                LoginView()
                    .environmentObject(coordinator)
                    .transition(rootTransition)

            case .main:
                NavigationStack(path: $navigation.path) {
                    MainTabView(postTransitionNamespace: feedPostTransitionNamespace)
                        .environmentObject(coordinator)
                        .navigationDestination(for: AppRoute.self) { route in
                            destinationView(for: route)
                        }
                }
                .transition(rootTransition)
            }
        }
        .id(navigation.root)
    }

    private var rootTransition: AnyTransition {
        switch (previousRoot, navigation.root) {
        case (.splash, .login):
            return .asymmetric(
                insertion: .offset(y: 36).combined(with: .opacity),
                removal: .scale(scale: 0.94).combined(with: .opacity)
            )

        case (.login, .main):
            return .asymmetric(
                insertion: .offset(x: 44).combined(with: .opacity),
                removal: .offset(x: -28).combined(with: .opacity)
            )

        case (.main, .login):
            return .asymmetric(
                insertion: .offset(x: -36).combined(with: .opacity),
                removal: .offset(x: 28).combined(with: .opacity)
            )

        default:
            return .opacity.combined(with: .scale(scale: 0.98))
        }
    }

    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .postDetail(let id, let sourceID):
            if let sourceID {
                PostDetailView(id: id, showsCloseButton: true)
                    .environmentObject(coordinator)
                    .navigationTransition(.zoom(sourceID: sourceID, in: feedPostTransitionNamespace))
                    .toolbar(.hidden, for: .tabBar)
            } else {
                PostDetailView(id: id, showsCloseButton: false)
                    .environmentObject(coordinator)
            }

        case .comments(let postID):
            CommentsView(postID: postID)
                .environmentObject(coordinator)

        case .profile(let username):
            ProfileView(username: username)
                .environmentObject(coordinator)
        }
    }

    @ViewBuilder
    private func sheetView(for route: AppSurfaceRoute) -> some View {
        switch route {
        case .error:
            ErrorView()
                .environmentObject(coordinator)

        case .forceUpdate:
            ForceUpdateView()
                .environmentObject(coordinator)

        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private func fullScreenView(for route: AppSurfaceRoute) -> some View {
        switch route {
        case .sessionExpired:
            SessionExpiredView()
                .environmentObject(coordinator)

        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private func bottomSheetView(for route: AppSurfaceRoute) -> some View {
        switch route {
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private func floatingView(for route: AppSurfaceRoute) -> some View {
        switch route {
        case .loading:
            LoadingOverlayView()

        default:
            EmptyView()
        }
    }

    private var sheetBinding: Binding<Bool> {
        Binding(
            get: { surface.sheet != nil },
            set: { if !$0 { surface.dismissSheet() } }
        )
    }

    private var fullScreenBinding: Binding<Bool> {
        Binding(
            get: { surface.fullScreen != nil },
            set: { if !$0 { surface.dismissFullScreen() } }
        )
    }

    private var bottomSheetBinding: Binding<Bool> {
        Binding(
            get: { surface.bottomSheet != nil },
            set: { if !$0 { surface.dismissBottomSheet() } }
        )
    }
}
