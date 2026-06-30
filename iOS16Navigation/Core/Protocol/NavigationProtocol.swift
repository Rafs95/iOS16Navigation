//
//  CoordinatorProtocol.swift
//  iOS16Navigation
//
//  Created by Raf on 29/06/26.
//

import SwiftUI
import Combine

@MainActor
public protocol NavigationProtocol {
    associatedtype Route: Hashable
    associatedtype Root
    
    var path: [Route] { get set }
    var root: Root { get set }
    
    func setRoot(_ root: Root)
    func push(_ route: Route)
    func push(_ routes: [Route])
    func setStack(_ routes: [Route])
    func replaceLast(with route: Route)
    func pop()
    func pop(_ count: Int)
    func popToRoot()
}

@MainActor
public class AppNavigation<Route: Hashable, Root: Hashable>: ObservableObject, NavigationProtocol {
    @Published public var path: [Route] = []
    @Published public var root: Root
    
    public init(path: [Route] = [], root: Root) {
        self.path = path
        self.root = root
    }
    
    public func push(_ route: Route) {
        path.append(route)
    }
    
    public func push(_ routes: [Route]) {
        path.append(contentsOf: routes)
    }
    
    public func setStack(_ routes: [Route]) {
        path = routes
    }
    
    public func replaceLast(with route: Route) {
        guard !path.isEmpty else {
            path = [route]
            return
        }
        
        path.removeLast()
        path.append(route)
    }
    
    public func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    public func pop(_ count: Int) {
        guard count > 0 else { return }
        
        let safeCount = min(count, path.count)
        path.removeLast(safeCount)
    }
    
    public func popToRoot() {
        path.removeAll()
    }
    
    public func setRoot(_ root: Root) {
        self.root = root
    }
}
