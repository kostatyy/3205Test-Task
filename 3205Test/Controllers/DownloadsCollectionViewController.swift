//
//  DownloadsCollectionViewController.swift
//  3205Test
//
//  Created by Macbook Pro on 29.07.2021.
//

import UIKit
import WebKit

class DownloadsCollectionViewController: UICollectionViewController {

    private var viewModel = DownloadsViewModel()
    
    private var addButton = UIButton()
    
    //MARK: - Git Web View
    private var gitWebView: WKWebView!
    private var authNavController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Downloads"
        navigationItem.largeTitleDisplayMode = .always
        
        customizeNavBarController()
        configure()
        setupViews()
    }
  
    private func configure() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height * 0.12)
        collectionView.collectionViewLayout = layout
        let nibCell = UINib(nibName: "DownloadsCollectionCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: DownloadsCollectionCell.reuseId)
    }
    
    private func setupViews() {
        addButton.backgroundColor = .red
        addButton.setImage(UIImage(systemName: "plus")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
        addButton.setupShadow(cornerRad: 13, shadowRad: 3, shadowOp: 0.3, offset: CGSize(width: 0, height: 5))
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.13),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30)
        ])
    }
    
    //MARK: - Open Screen To Search/Add New Repositories
    @objc private func didTapAddButton() {
        let searchVC: SearchViewController = .instantiate()
        let searchViewModel = SearchViewModel()
        searchVC.viewModel = searchViewModel
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    //MARK: - Open Login Screen
    @IBAction func didTapLoginButton(_ sender: Any) {
        if GitHubAPIClient.shared.isSignedIn {
            let alert = UIAlertController(title: "Sign Out", message: "Do you want to sign out?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default) { action in
                self.dismiss(animated: true) {
                    self.viewModel.logoutFromGit()
                }
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { action in
                self.dismiss(animated: true, completion: nil)
            })
            present(alert, animated: true)
        } else {
            gitWebView = WKWebView()
            self.gitAuthVC(gitWebView: gitWebView)
        }
    }
    
}

extension DownloadsCollectionViewController: WKNavigationDelegate {
    
    //MARK: - Show VK Login Screen
    func gitAuthVC(gitWebView: WKWebView) {
        let gitVC = UIViewController()
        
        gitWebView.navigationDelegate = self
        gitVC.view.addSubview(gitWebView)
        gitWebView.frame = gitVC.view.bounds
        gitWebView.translatesAutoresizingMaskIntoConstraints = false

        guard let urlRequest = GitHubAPIClient.shared.signInUrlRequest else { return }
        gitWebView.load(urlRequest)
        
        authNavController = UINavigationController(rootViewController: gitVC)
        authNavController.setNavigationBarHidden(true, animated: false)
        
        self.present(authNavController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        viewModel.requestForCallbackURL(request: navigationAction.request) { result in
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    if let result = result {
                        self.callErrorAlert(message: result)
                    }
                }
            }
        }
        
        decisionHandler(.allow)
    }
    
    //MARK: - Handling Auth Errors
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        let message: String = error.localizedDescription
//        authNavController.callErrorAlert(message: message)
    }
}


extension DownloadsCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DownloadsCollectionCell.reuseId, for: indexPath) as! DownloadsCollectionCell
        return cell
    }
}
