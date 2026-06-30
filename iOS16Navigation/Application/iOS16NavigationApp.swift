//
//  iOS16NavigationApp.swift
//  iOS16Navigation
//
//  Created by Raf on 29/06/26.
//

import SwiftUI

@main
struct iOS16NavigationApp: App {
    init() {
        NukeSupport.configureSharedPipelineIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
