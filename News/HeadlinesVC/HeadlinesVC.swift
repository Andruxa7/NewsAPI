//
//  HeadlinesVC.swift
//  News
//
//  Created by Andrii Stetsenko on 17.03.2024.
//

import UIKit
import SafariServices

class HeadlinesVC: UIViewController {
    
    //Create a tableView
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(HeadlinesTableViewCell.self, forCellReuseIdentifier: HeadlinesTableViewCell.identifier)
        return table
    }()
    
    private let searchVC = UISearchController(searchResultsController: nil)
    private var articles = [Article]()
    private var totalApiResults: Int = 0
    private var currentPage: Int = 1
    var category: String? = nil
    let titleName: String = "Top News"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchMyCategoryStories()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // Show tab bar
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Set to large title
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        if category != nil {
            self.navigationItem.title = category
        } else {
            self.navigationItem.title = titleName
            createSearchBar()
        }
        
        self.navigationController?.navigationBar.sizeToFit()
    }
    
    
    private func fetchMyCategoryStories() {
        NetworkManager.shared.onCompletionData = { [weak self] result in
            guard let self = self else { return }
            self.articles = result.articles
            self.totalApiResults = result.totalResults
            
            // table view should refresh
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        NetworkManager.shared.getMyCategoryStories(by: category ?? "General", andPage: String(currentPage))
    }
    
    
    //MARK: - ViewDidLayoutSubViews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
        searchVC.searchBar.placeholder = "Search for news"
    }
}


//MARK: - extension for HeadlinesVC
extension HeadlinesVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeadlinesTableViewCell.identifier,
                                                       for: indexPath) as? HeadlinesTableViewCell else { fatalError() }
        cell.configure(with: articles[indexPath.row])
        
        return cell
    }
    
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        guard let url = URL(string: article.url ?? "https://picsum.photos/200/300") else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == articles.count - 1 {
            if currentPage > 0 {
                guard articles.count < totalApiResults else { return }
                
                currentPage += 1
                print("LAST PAGE!!!")
                
                NetworkManager.shared.onCompletionData = { [weak self] result in
                    guard let self = self else { return }
                    self.articles.append(contentsOf: result.articles)
                    
                    // table view should refresh
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                NetworkManager.shared.getMyCategoryStories(by: category ?? "General", andPage: String(currentPage))
            }
        }
    }
    
    // UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        
        NetworkManager.shared.onCompletionData = { [weak self] result in
            guard let self = self else { return }
            self.articles = result.articles
            
            // table view should refresh
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.searchVC.dismiss(animated: true, completion: nil)
                
                // Change title
                self.navigationController?.navigationBar.prefersLargeTitles = false
                self.navigationItem.title = "News for: \(text)"
            }
        }
        NetworkManager.shared.searchURL(with: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        currentPage = 1
        fetchMyCategoryStories()
        
        // Change title
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = titleName
    }
}
