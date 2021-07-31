//
//  SearchViewModel.swift
//  3205Test
//
//  Created by Macbook Pro on 30.07.2021.
//

import UIKit

class SearchViewModel {
    
    var visibleRepositories = [RepositoryItem]()
    var searchUser = ""
    var pageNum = 1
    var maxVisibleRepositories = Constants.APIDetails.repositoriesPerPage
    
    // MARK: - Search GitHub User
    func searchForUser(completion: @escaping (String?)->()) {
        GitHubAPIClient.shared.getUser(for: searchUser) { result in
            switch result {
            case .success(let user):
                if user.public_repos > 0 {
                    self.searchForRepositories(for: user) {
                        completion(nil)
                    }
                } else if user.public_repos == 0 { completion("There are not repositores for user '\(self.searchUser)'")}
            case .failure(_):
                self.visibleRepositories = []
                completion("User '\(self.searchUser)' not found")
            }
        }
    }
    
    //MARK: - Search GitHub User's Repositories
    private func searchForRepositories(for user: GitHubUser, completion: @escaping ()->()) {
        GitHubAPIClient.shared.getRepositories(for: user.login, pageNum: pageNum) { (result) in
            switch result {
            case .success(let repositories):
                self.visibleRepositories += repositories
            case .failure(_):
                self.visibleRepositories = []
            }
            completion()
        }
    }
    
}
