//
//  MainTabView.swift
//  iOS16Navigation
//
//  Created by Raf on 29/06/26.
//

import SwiftUI

struct MainTabView: View {
    let postTransitionNamespace: Namespace.ID

    @State private var selectedTab: AppTab = .feed

    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView(postTransitionNamespace: postTransitionNamespace)
                .tabItem {
                    Label("Feed", systemImage: "house.fill")
                }
                .tag(AppTab.feed)

            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "safari.fill")
                }
                .tag(AppTab.explore)

            CurrentUserProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
                .tag(AppTab.profile)
        }
    }
}

private enum AppTab {
    case feed
    case explore
    case profile
}
