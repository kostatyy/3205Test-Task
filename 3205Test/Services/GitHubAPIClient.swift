//
//  GitHubAPIClient.swift
//  3205Test
//
//  Created by Macbook Pro on 30.07.2021.
//

import UIKit

struct Constants {
    struct APIDetails {
        static let repositoriesPerPage = 30
        static let baseUrl = "https://api.github.com/"
        static let baseAuthApi = "https://github.com/login/oauth/"
    }
}

class GitHubAPIClient {
    
    static let shared = GitHubAPIClient()
    
    public var isSignedIn: Bool {
        return accessToken != nil
    }
    
    //MARK: - Access Token
    private var accessToken: String? {
        guard let data = KeychainHelper.standard.read(service: "access-token", account: "github"),
              let accessToken = String(data: data, encoding: .utf8) else { return nil }
        return accessToken
    }
    
    //MARK: - Git SignIn URL Request
    public var signInUrlRequest: URLRequest? {
        let urlString = "\(Constants.APIDetails.baseAuthApi)authorize?client_id=\(Secrets.clientId)&redirect_uri=\(Secrets.redirectUri)&scope=\(Secrets.scopes)&response_type=code"
        guard let url = URL(string: urlString) else { return nil }
        let urlRequest = URLRequest.init(url: url)
        return urlRequest
    }
    
    //MARK: - Get GitHub User Info
    public func getUser(for userName: String, completion: @escaping (Result<GitHubUser, Error>)->()) {
        let urlString = Constants.APIDetails.baseUrl + "users/\(userName)"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        if isSignedIn { request.setValue("token \(accessToken!)", forHTTPHeaderField: "Authorization") }
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let gitUser: GitHubUser = try decoder.decode(GitHubUser.self, from: data)
                completion(.success(gitUser))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    //MARK: - Get List Of Repositories For User
    public func getRepositories(for userName: String, pageNum: Int, completion: @escaping (Result<[RepositoryItem], Error>) -> Void) {
        let urlString = Constants.APIDetails.baseUrl + "users/\(userName)/repos"
        guard var components = URLComponents(string: urlString) else { return }
        components.queryItems = [
            URLQueryItem(name: "per_page", value: "\(Constants.APIDetails.repositoriesPerPage)"),
            URLQueryItem(name: "page", value: "\(pageNum)"),
        ]
        
        guard let url = components.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        if isSignedIn { request.setValue("token \(accessToken!)", forHTTPHeaderField: "Authorization") }

        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
//                let res = try JSONSerialization.jsonObject(with: data, options: [])
//                print(res)
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
        let authAPI = "\(Constants.APIDetails.baseAuthApi)access_token?client_id=\(Secrets.clientId)&client_secret=\(Secrets.clientSecret)&redirect_uri=\(Secrets.redirectUri)&code=\(code)"
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
