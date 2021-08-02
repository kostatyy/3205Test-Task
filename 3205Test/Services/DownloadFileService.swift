//
//  Downloader.swift
//  3205Test
//
//  Created by Macbook Pro on 01.08.2021.
//

import UIKit

enum DownloadError: String, Error {
    case fileExist = "This File Already Exists!"
    case notDownloaded = "File Cannot Be Downloaded!"
}

class DownloadFileService {
    
    static var shared = DownloadFileService()
    
    private var documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    //MARK: - Checking If Repository Already Exists In Documents
    public func repositoryExists(repository: RepositoryItem) -> Bool {
        var searchDirectory = documentsDirectoryUrl
        searchDirectory.appendPathComponent("\(repository.id).zip")
        return FileManager.default.fileExists(atPath: searchDirectory.path)
    }
    
    //MARK: - Download File
    public func downloadFile(url: URL, repositoryId: Int, completion: @escaping (Result<String?, DownloadError>) -> ()) {
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")

        let task = URLSession.shared.downloadTask(with: request) { (tempLocalUrl, response, error) in

            guard error == nil else { return }
            guard let tempLocalUrl = tempLocalUrl else { return }

            var saveDirectoryUrl = self.documentsDirectoryUrl
            saveDirectoryUrl.appendPathComponent("\(repositoryId).zip")
            
            do {
                try FileManager.default.copyItem(at: tempLocalUrl, to: saveDirectoryUrl)
                completion(.success(nil))
            } catch (_) {
                completion(.failure(.notDownloaded))
            }
        }
        task.resume()
    }
    
    //MARK: - Delete File
    public func deleteFile(repositoryId: Int, completion: @escaping (Error?) -> ()) {
        var deleteUrl = documentsDirectoryUrl
        deleteUrl.appendPathComponent("\(repositoryId).zip")
        
        do {
            try FileManager.default.removeItem(atPath: deleteUrl.path)
            completion(nil)
        } catch(let error) {
            completion(error)
        }
    }
}
