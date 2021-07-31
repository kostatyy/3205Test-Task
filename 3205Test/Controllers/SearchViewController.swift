//
//  SearchViewController.swift
//  3205Test
//
//  Created by Macbook Pro on 30.07.2021.
//

import UIKit

class SearchViewController: UITableViewController {

    @IBOutlet var searchBar: UISearchBar!
    
    var viewModel: SearchViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        customizeNavBarController()
        navigationItem.titleView = searchBar
        navigationItem.largeTitleDisplayMode = .never
        setupSearchBar()
        configure()
    }
    
    private func configure() {
        let nibCell = UINib(nibName: "SearchTableCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "CellId")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as! SearchTableCell
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
//            print("Loading...")
            viewModel.pageNum += 1
            viewModel.maxVisibleRepositories += Constants.APIDetails.repositoriesPerPage
            viewModel.searchForUser { result in
                if let result = result { print(result)}
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

}

//MARK: - Search Bar Ext To Filter Visible Spotify Tracks
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.maxVisibleRepositories = Constants.APIDetails.repositoriesPerPage
        viewModel.visibleRepositories = []
        viewModel.pageNum = 1
        viewModel.searchUser = searchText
        viewModel.searchForUser { result in
            if let result = result { print(result)}
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.setContentOffset(CGPoint(x: 0, y: -self.tableView.contentInset.top), animated: true)
            }
        }
    }
}
