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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
    }
    
    //MARK: - Setting Up Search Bar
    private func setupSearchBar() {
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(viewModel.visibleRepositories.count)
        return viewModel.visibleRepositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
        cell.textLabel?.text = viewModel.visibleRepositories[indexPath.row].name
        return cell
    }

}

//MARK: - Search Bar Ext To Filter Visible Spotify Tracks
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchForRepository(for: searchText) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
