//
//  SearchViewModel.swift
//  3205Test
//
//  Created by Macbook Pro on 30.07.2021.
//

import UIKit

class SearchViewModel {
    
    var visibleRepositories = [RepositoryItem]()
    
    func searchForRepository(for user: String, completion: @escaping ()->()) {
        GitHubAPIClient.shared.getRepositories(for: user, pageNum: 1) { (result) in
            switch result {
            case .success(let repositories):
                self.visibleRepositories = repositories
            case .failure(let error):
                self.visibleRepositories = []
            }
            completion()
        }
    }
    
}
