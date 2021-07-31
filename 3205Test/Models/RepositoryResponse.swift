//
//  RepositoryResponse.swift
//  3205Test
//
//  Created by Macbook Pro on 30.07.2021.
//

import Foundation

struct RepositoryItem: Codable {
    var id: Int
    var name: String
    var url: String
    var owner: RepositoryOwner
    var created_at: String
    var description: String?
    var html_url: String
}

struct RepositoryOwner: Codable {
    var login: String
}
