//
//  GitHubAPIClient.swift
//  3205Test
//
//  Created by Macbook Pro on 30.07.2021.
//

import UIKit

class GitHubAPIClient {
    
    static let shared = GitHubAPIClient()
    private let baseUrl = "https://api.github.com/"
    private let baseAuthApi = "https://github.com/login/oauth/"
    
    public var isSignedIn: Bool {
        guard let data = KeychainHelper.standard.read(service: "access-token", account: "github"),
              let accessToken = String(data: data, encoding: .utf8) else { return false }
        print(accessToken)
        return true
    }
    
    //MARK: - Git SignIn URL Request
    public var signInUrlRequest: URLRequest? {
        let urlString = "\(baseAuthApi)authorize?client_id=\(Secrets.clientId)&redirect_uri=\(Secrets.redirectUri)&scope=\(Secrets.scopes)&response_type=code"
        guard let url = URL(string: urlString) else { return nil }
        let urlRequest = URLRequest.init(url: url)
        return urlRequest
    }
    
    //MARK: - Get List Of Repositories For User
    public func getRepositories(for userName: String, pageNum: Int, completion: @escaping (Result<[RepositoryItem], Error>) -> Void) {
        let urlString = baseUrl + "users/\(userName)/repos"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
//        request.setValue("\(pageNum)", forHTTPHeaderField: "page")
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let repositories: [RepositoryItem] = try decoder.decode([RepositoryItem].self, from: data)
                completion(.success(repositories))
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    //MARK: - Exchanging authorization code for access token
    public func exchangeCodeForToken(code: String, completion: @escaping ((Error?) -> Void)) {
        let authAPI = "\(baseAuthApi)access_token?client_id=\(Secrets.clientId)&client_secret=\(Secrets.clientSecret)&redirect_uri=\(Secrets.redirectUri)&code=\(code)"
        guard let url = URL(string: authAPI) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard let accessToken = result!["access_token"] as? String else { return }
                
                // Save Token To KeyChain
                let data = Data(accessToken.utf8)
                KeychainHelper.standard.save(data, service: "access-token", account: "github")
                completion(nil)
            } catch {
                completion(error)
            }
        }
        
        task.resume()
    }
    
}
