//
//  SelectedRepositoryViewController.swift
//  3205Test
//
//  Created by Macbook Pro on 31.07.2021.
//

import UIKit
import WebKit

class SelectedRepositoryViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoOwnerName: UILabel!
    @IBOutlet weak var repoDateCreated: UILabel!
    @IBOutlet weak var repoDescription: UITextView!
    
    @IBOutlet weak var openInBrowserView: UIView!
    @IBOutlet weak var downloadView: UIView!
    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: SelectedRepositoryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeNavBarController(clear: true)
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bgView.roundCorners([.bottomLeft, .bottomRight], radius: 40)
    }
    
    private func setupViews() {
        guard let repository = viewModel.repository else { return }
        repoName.text = repository.name
        repoOwnerName.text = repository.owner.login
        repoDateCreated.text = repository.created_at.formatDate()
        repoDescription.text = repository.description
        
        activityIndicator.color = .mainColor
        
        openInBrowserView.layer.borderWidth = 1
        openInBrowserView.layer.borderColor = UIColor.mainColor.cgColor
        openInBrowserView.layer.cornerRadius = 30
        downloadView.layer.cornerRadius = 30
        
        downloadView.backgroundColor = viewModel.repositoryExists() ? .lightGray : .mainColor
        downloadLabel.text = viewModel.repositoryExists() ? "Downloaded" : "Download"
        
        openInBrowserView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openInBrowser)))
        downloadView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(downloadRepository)))
    }
    
    //MARK: - Open Repository In Browser
    @objc private func openInBrowser() {
        if let repository = viewModel.repository,
           let url = URL(string: repository.html_url) {
            UIApplication.shared.open(url)
        }
    }
    
    //MARK: - Download Or Delete Repository
    @objc private func downloadRepository() {
        if !viewModel.repositoryExists() {
            startActivityIndicator()
            viewModel.downloadRepositoryZip { (result) in
                self.stopActivityIndicator()
                if let result = result {
                    self.callErrorAlert(message: result)
                } else {
                    self.downloadView.backgroundColor = .lightGray
                    self.downloadLabel.text = "Downloaded"
                }
            }
        }
    }
    
}

extension SelectedRepositoryViewController {
    func startActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}
