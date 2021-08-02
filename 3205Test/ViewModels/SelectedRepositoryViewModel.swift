//
//  SelectedRepositoryViewModel.swift
//  3205Test
//
//  Created by Macbook Pro on 01.08.2021.
//

import UIKit

class SelectedRepositoryViewModel {
    
    var repository: RepositoryItem?
    
    //MARK: - Checking If Repository Already Exists In Documents
    func repositoryExists() -> Bool {
        guard let repository = repository else { return false }
        return DownloadFileService.shared.repositoryExists(repository: repository)
    }
    
    //MARK: - Download Repository
    func downloadRepositoryZip(completion: @escaping (String?)->()) {
        guard let repository = repository else { return }
        let ownerName = repository.owner.login
        let repoName = repository.name
        
        let urlString = APIDetails.baseUrl + "repos/\(ownerName)/\(repoName)/zipball"
        guard let url = URL(string: urlString) else { return }
        
        DownloadFileService.shared.downloadFile(url: url, repositoryId: repository.id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    RepositoriesCoreDataManager.shared.saveRepository(repositoryInfo: repository)
                    completion(nil)
                case .failure(let error):
                    completion(error.rawValue)
                }
            }
        }
    }
    
    //MARK: - Delete Repository
    func deleteRepository(completion: @escaping (String?)->()) {
        guard let repository = repository else { return }
        DownloadFileService.shared.deleteFile(repositoryId: repository.id) { (result) in
            DispatchQueue.main.async {
                if let result = result {
                    completion(result.localizedDescription)
                }
            }
        }
    }
}
