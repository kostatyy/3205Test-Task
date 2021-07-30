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
}

struct RepositoryOwner: Codable {
    var login: String
}
