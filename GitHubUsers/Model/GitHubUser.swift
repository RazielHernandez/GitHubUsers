//
//  GitHubUser.swift
//  GitHubUsers
//
//  Created by Raziel Hernandez on 2025-04-06.
//

import Foundation

struct GitHubUser: Codable {
    let login: String
    let avatar_url: String
    let html_url: String
    let name: String?
    let bio: String?
    let location: String?
    let public_repos: Int
    let followers: Int
    let following: Int
}

struct GitHubSimpleUser: Identifiable, Codable {
    let id = UUID()
    let login: String
    let avatar_url: String

    enum CodingKeys: String, CodingKey {
        case login
        case avatar_url
    }
}
