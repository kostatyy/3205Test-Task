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
        
        openInBrowserView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openInBrowser)))
    }
    
    //MARK: - Open Repository In Browser
    @objc private func openInBrowser() {
        if let repository = viewModel.repository,
           let url = URL(string: repository.html_url) {
            UIApplication.shared.open(url)
        }
    }
    
    //MARK: - Download Repository
    @objc private func downloadRepository() {
        
    }
    
}
