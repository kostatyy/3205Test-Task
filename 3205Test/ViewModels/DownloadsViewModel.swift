//
//  DownloadsViewModel.swift
//  3205Test
//
//  Created by Macbook Pro on 30.07.2021.
//

import UIKit

class DownloadsViewModel {
    
    var repositories: [Repository] = []
    
    //MARK: - Get List Of Saved Repositories
    func getDownloadedRepositories(completion: @escaping ()->()) {
        let savedRepos = RepositoriesCoreDataManager.shared.fetchRepositories()
        repositories = []
        for repo in savedRepos {
            self.repositories.insert(repo, at: 0)
        }
        completion()
    }
        
    //MARK: - GitHub Auth
    func requestForCallbackURL(request: URLRequest, completion: @escaping (String?)->()) {
        let requestURLString = (request.url?.absoluteString)! as String
        
        let component = URLComponents(string: requestURLString)
        guard let code = component?.queryItems?.first(where: { $0.name == "code" })?.value else {
            return
        }
        GitHubAPIClient.shared.exchangeCodeForToken(code: code) { (result) in
            completion(result?.localizedDescription)
        }
    }
    
    //MARK: - LogOut From GitHub
    func logoutFromGit() {
        KeychainHelper.standard.delete(service: "access-token", account: "github")
    }
    
}
