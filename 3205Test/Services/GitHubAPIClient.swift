//
//  GitHubAPIClient.swift
//  3205Test
//
//  Created by Macbook Pro on 30.07.2021.
//

import UIKit

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
        let urlString = "\(APIDetails.baseAuthApi)" + "authorize"
        
        guard var components = URLComponents(string: urlString) else { return nil }
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "\(Secrets.clientId)"),
            URLQueryItem(name: "redirect_uri", value: "\(Secrets.redirectUri)"),
            URLQueryItem(name: "scope", value: "\(Secrets.scopes)"),
            URLQueryItem(name: "response_type", value: "code")
        ]
        
        guard let url = components.url else { return nil }

        return URLRequest(url: url)
    }
    
    //MARK: - Get GitHub User Info
    public func getUser(for userName: String, completion: @escaping (Result<GitHubUser, Error>)->()) {
        let urlString = APIDetails.baseUrl + APIDetails.users + "\(userName)"
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
        let urlString = APIDetails.baseUrl + APIDetails.users + "\(userName)/" + APIDetails.repos
        guard var components = URLComponents(string: urlString) else { return }
        components.queryItems = [
            URLQueryItem(name: "per_page", value: "\(APIDetails.repositoriesPerPage)"),
            URLQueryItem(name: "page", value: "\(pageNum)"),
        ]
        
        guard let url = components.url else { return }
        var request = URLRequest(url: url)
        
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        if isSignedIn { request.setValue("token \(accessToken!)", forHTTPHeaderField: "Authorization") }

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
        let authAPI = "\(APIDetails.baseAuthApi)access_token"
        
        guard var components = URLComponents(string: authAPI) else { return }
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "\(Secrets.clientId)"),
            URLQueryItem(name: "client_secret", value: "\(Secrets.clientSecret)"),
            URLQueryItem(name: "redirect_uri", value: "\(Secrets.redirectUri)"),
            URLQueryItem(name: "code", value: "\(code)")
        ]
        
        guard let url = components.url else { return }
 
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
