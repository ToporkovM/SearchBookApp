//
//  StartViewController.swift
//  SearchBookApp
//
//  Created by m.toporkov on 12.03.2022.
//

import UIKit

final class StartViewController: UITableViewController {
    
    private var resultSearchController = UISearchController(searchResultsController: nil)
    
    private let service = NetworkService.shared
    
    private var resultModel: SearchBooksModel? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchBar()
        setupTableView()
    }
}

extension StartViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = resultModel?.items {
            return items.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        
        guard let items = resultModel?.items else {
            return defaultCell
        }
        
        guard let cell = tableView.dequeue(InfoTableViewCell.self) else {
            fatalError("InfoTableViewCell Not Found")
        }
        
        cell.configure(authors: items[safe: indexPath.row]?.volumeInfo.authors ?? [],
                       name: items[safe: indexPath.row]?.volumeInfo.title ?? "-")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = resultModel?.items?[safe: indexPath.row] else { return }
        
        let viewController = DetailCardViewController()
        viewController.model = model
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension StartViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        //обязательный метод делегата, но в данном приложении он не нужен
        print("")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text.count >= 2 {
            resultSearchController.searchBar.resignFirstResponder()
            resultSearchController.isActive = false
            service.getBooks(searchWord: text) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let model):
                    self.resultModel = model
                }
            }
            resultSearchController.isActive = true
        }
    }
}

private extension StartViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InfoTableViewCell.nib, forCellReuseIdentifier: InfoTableViewCell.identifier)
    }
    
    func initSearchBar() {
        resultSearchController.searchBar.delegate = self
        resultSearchController.searchResultsUpdater = self
        resultSearchController.obscuresBackgroundDuringPresentation = false
        resultSearchController.searchBar.placeholder = "Search books"
        navigationItem.searchController = resultSearchController
        definesPresentationContext = true
    }
}
