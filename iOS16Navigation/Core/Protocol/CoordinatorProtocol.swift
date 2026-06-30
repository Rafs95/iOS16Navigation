//
//  CoordinatorProtocol.swift
//  iOS16Navigation
//
//  Created by Raf on 29/06/26.
//


import Foundation
import UIKit

@MainActor
public protocol CoordinatorProtocol: AnyObject {
    func start()
    func reset()

    @discardableResult
    func open(url: URL) -> Bool

    @discardableResult
    func continueUserActivity(_ userActivity: NSUserActivity) -> Bool

    @discardableResult
    func handleWidgetURL(_ url: URL) -> Bool

    @discardableResult
    func handleLiveActivityURL(_ url: URL) -> Bool

    @discardableResult
    func handleRemoteNotification(userInfo: [AnyHashable: Any]) -> Bool

    @discardableResult
    func handleLocalNotification(userInfo: [AnyHashable: Any]) -> Bool

    @discardableResult
    func handleQuickAction(_ shortcutItem: UIApplicationShortcutItem) -> Bool
}

@MainActor
public extension CoordinatorProtocol {
    func start() {}

    func reset() {}

    @discardableResult
    func open(url: URL) -> Bool {
        false
    }

    @discardableResult
    func continueUserActivity(_ userActivity: NSUserActivity) -> Bool {
        false
    }

    @discardableResult
    func handleWidgetURL(_ url: URL) -> Bool {
        open(url: url)
    }

    @discardableResult
    func handleLiveActivityURL(_ url: URL) -> Bool {
        open(url: url)
    }

    @discardableResult
    func handleRemoteNotification(userInfo: [AnyHashable: Any]) -> Bool {
        false
    }

    @discardableResult
    func handleLocalNotification(userInfo: [AnyHashable: Any]) -> Bool {
        false
    }
    
    @discardableResult
    func handleQuickAction(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        false
    }
}
