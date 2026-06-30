//
//  AppLinkDestination.swift
//  iOS16Navigation
//
//  Created by Raf on 29/06/26.
//

public enum AppLinkDestination: Hashable {
    case post(id: String)
    case comments(postID: String)
    case profile(username: String)
}
