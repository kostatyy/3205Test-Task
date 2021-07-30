//
//  DownloadsViewModel.swift
//  3205Test
//
//  Created by Macbook Pro on 30.07.2021.
//

import UIKit

class DownloadsViewModel {
    
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
