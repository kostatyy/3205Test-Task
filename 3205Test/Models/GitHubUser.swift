//
//  GitHubUser.swift
//  3205Test
//
//  Created by Macbook Pro on 31.07.2021.
//

import Foundation

struct GitHubUser: Codable {
    var login: String
    var name: String?
    var public_repos: Int
}
