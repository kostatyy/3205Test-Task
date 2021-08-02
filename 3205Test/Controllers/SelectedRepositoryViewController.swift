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
    
    private var activityIndicator = UIActivityIndicatorView()

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
        showActivityIndicator(alpha: 1)
        if !viewModel.repositoryExists() {
            viewModel.downloadRepositoryZip { (result) in
                self.hideActivityIndicator()
                if let result = result {
                    self.callErrorAlert(message: result)
                } else {
                    self.downloadView.backgroundColor = .lightGray
                    self.downloadLabel.text = "Downloaded"
                }
            }
        }
//        if viewModel.repositoryExists() {
//            let alert = UIAlertController(title: "Delete Repository", message: "Do you want to delete this repository?", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Yes", style: .default) { action in
//                self.dismiss(animated: true) {
//                    self.viewModel.deleteRepository { (result) in
//                        if let result = result {
//                            self.callErrorAlert(message: result)
//                        }
//                    }
//                }
//            })
//            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { action in
//                self.dismiss(animated: true, completion: nil)
//            })
//            present(alert, animated: true)
//        }
    }
    
}
