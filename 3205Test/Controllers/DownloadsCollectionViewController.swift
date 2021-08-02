//
//  DownloadsCollectionViewController.swift
//  3205Test
//
//  Created by Macbook Pro on 29.07.2021.
//

import UIKit
import WebKit

class DownloadsCollectionViewController: UICollectionViewController {

    @IBOutlet weak var userBarButtonImage: UIBarButtonItem!
    private var viewModel = DownloadsViewModel()
    
    private var warningLabel = UILabel()
    private var addButton = UIButton()
    
    //MARK: - Git Web View
    private var gitWebView: WKWebView!
    private var authNavController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Downloads"
        
        configure()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if GitHubAPIClient.shared.isSignedIn {
            userBarButtonImage.image = #imageLiteral(resourceName: "logout-icon")
        } else {
            userBarButtonImage.image = #imageLiteral(resourceName: "user-icon")
        }
        
        viewModel.getDownloadedRepositories {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.warningLabel.alpha = self.viewModel.repositories.count == 0 ? 1 : 0
                self.customizeNavBarController()
            }
        }
    }
  
    private func configure() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height * 0.12)
        collectionView.collectionViewLayout = layout
        let nibCell = UINib(nibName: "DownloadsCollectionCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: DownloadsCollectionCell.reuseId)
    }
    
    private func setupViews() {
        addButton.backgroundColor = .mainColor
        addButton.setImage(#imageLiteral(resourceName: "plus-icon"), for: .normal)
        addButton.setupShadow(cornerRad: 13, shadowRad: 3, shadowOp: 0.3, offset: CGSize(width: 0, height: 5))
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        warningLabel.text = "There Are No Downlaoded Repositories Yet"
        warningLabel.alpha = 0
        warningLabel.textColor = .lightGray
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(warningLabel)
        
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.13),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor),
            addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            
            warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            warningLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30)
        ])
        
        if #available(iOS 11.0, *) {
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
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
}

extension DownloadsCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DownloadsCollectionCell.reuseId, for: indexPath) as! DownloadsCollectionCell
        cell.repositoryName.text = viewModel.repositories[indexPath.row].name
        cell.repositoryOwnerName.text = viewModel.repositories[indexPath.row].ownerName
        return cell
    }
}
