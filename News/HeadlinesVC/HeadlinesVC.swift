//
//  HeadlinesVC.swift
//  News
//
//  Created by Andrii Stetsenko on 17.03.2024.
//

import UIKit
import SafariServices

extension HeadlinesVC: ViewModelDelegate {
    func loadArticles(_ articles: [Article]) {
        self.articles = articles
        DispatchQueue.main.async {
            self.createSnapshot()
        }
    }
}

class HeadlinesVC: UIViewController {
    
    //Create a tableView
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(HeadlinesTableViewCell.self, forCellReuseIdentifier: HeadlinesTableViewCell.identifier)
        return table
    }()
    
    private let viewModel = ViewModel()
    private var articles = [Article]()
    
    var dataSource: UITableViewDiffableDataSource<Section, Article>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, Article>! = nil
    
    private let searchVC = UISearchController(searchResultsController: nil)

    var category: String? = nil
    let titleName: String = "Top News"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.delegate = self
        viewModel.delegate = self
        
        fetchMyCategoryStories()
        createDataSource()
        createSnapshot()
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
    
    //MARK: - ViewDidLayoutSubViews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - DataSource
    func createDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, article in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HeadlinesTableViewCell.identifier,
                                                           for: indexPath) as? HeadlinesTableViewCell else { fatalError() }
            
            cell.configure(with: self.articles[indexPath.row])
            
            return cell
        })
        
        dataSource.defaultRowAnimation = .fade
        tableView.dataSource = dataSource
    }
    
    func createSnapshot() {
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, Article>()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(articles)
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
    
    private func fetchMyCategoryStories() {
        viewModel.fetchArticlesWithDelegate()
        viewModel.getMyCategoryStories(by: category ?? "General")
    }
    
    private func createSearchBar() {
        navigationItem.searchController = searchVC
        //делаем так чтобы серчбар не пропадал при скроллинге таблицы
        navigationItem.hidesSearchBarWhenScrolling = false
        searchVC.hidesNavigationBarDuringPresentation = false
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.delegate = self
        searchVC.searchBar.placeholder = "Search for news"
    }
}


//MARK: - extension for HeadlinesVC
extension HeadlinesVC: UITableViewDelegate, UISearchBarDelegate {
    
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
            viewModel.loadNextPage(by: category ?? "General")
        }
    }
    
    // UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        
        viewModel.fetchArticlesWithDelegate()
        
        self.searchVC.dismiss(animated: true, completion: nil)
        
        // Change title
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "News for: \(text)"
        
        viewModel.searchURL(with: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.currentPage = 1
        fetchMyCategoryStories()
        
        // Change title
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = titleName
    }
}
