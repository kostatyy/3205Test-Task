//
//  SearchViewController.swift
//  3205Test
//
//  Created by Macbook Pro on 30.07.2021.
//

import UIKit

class SearchViewController: UITableViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var errorLabel = UILabel()
    
    var viewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchBar
        setupSearchBar()
        setupViews()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        customizeNavBarController()
    }
    
    private func configure() {
        let nibCell = UINib(nibName: "SearchTableCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: SearchTableCell.reuseId)
    }
    
    private func setupViews() {
        errorLabel.alpha = 0
        errorLabel.textColor = .lightGray
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.layer.zPosition = 3
        
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30)
        ])
    }
    
    //MARK: - Setting Up Search Bar
    private func setupSearchBar() {
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.visibleRepositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableCell.reuseId, for: indexPath) as! SearchTableCell
        cell.repositoryName.text = viewModel.visibleRepositories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.08
    }
    
    //MARK: - Loading More Repositories
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = viewModel.maxVisibleRepositories - 1
        if indexPath.row == lastElement {
            viewModel.pageNum += 1
            viewModel.maxVisibleRepositories += APIDetails.repositoriesPerPage
            viewModel.searchForUser { result in
                DispatchQueue.main.async {
                    if let result = result, self.viewModel.searchUser.count > 0 {
                        self.errorLabel.text = result
                        self.errorLabel.alpha = 1
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - Go To Selected Repository
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repositoryVC: SelectedRepositoryViewController = .instantiate()
        let repositoryViewModel = SelectedRepositoryViewModel()
        repositoryViewModel.repository = viewModel.visibleRepositories[indexPath.row]
        repositoryVC.viewModel = repositoryViewModel
        navigationController?.pushViewController(repositoryVC, animated: true)
    }
}

//MARK: - Search Bar Ext To Filter Visible Spotify Tracks
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reload), object: nil)
        self.perform(#selector(reload), with: nil, afterDelay: 0.2)
    }
    
    @objc func reload() {
        guard let searchText = searchBar.text else { return }
        errorLabel.alpha = 0
        activityIndicator.startAnimating()
        viewModel.maxVisibleRepositories = APIDetails.repositoriesPerPage
        viewModel.visibleRepositories = []
        viewModel.pageNum = 1
        viewModel.searchUser = searchText
        DispatchQueue.global(qos: .utility).async {
            self.viewModel.searchForUser { result in
                DispatchQueue.main.async {
                    if let result = result, self.viewModel.searchUser.count > 0 {
                        self.errorLabel.text = result
                        self.errorLabel.alpha = 1
                    }
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                    self.tableView.setContentOffset(CGPoint(x: 0, y: -self.tableView.contentInset.top), animated: true)
                }
            }
        }
        
    }
}
