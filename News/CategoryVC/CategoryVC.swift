//
//  CategoryVC.swift
//  News
//
//  Created by Andrii Stetsenko on 13.03.2024.
//

import UIKit

class CategoryVC: UIViewController {
    
    let category = ["General", "Business", "Science", "Technology", "Health", "Entertainment", "Sports"]
    
    var categoryCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        configureNavigationBar()
    }
    
    
    func configureCollectionView() {
        // Create an instance of UICollectionViewFlowLayout since you cant initialize UICollectionView without a layout
        let customLayout = CustomFlowLayout()
        
        categoryCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: customLayout)
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        categoryCollectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.view.addSubview(categoryCollectionView)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "News by Category"
        self.navigationController!.tabBarItem.title = "Categories"
    }

}

// MARK: - UICollectionViewDataSource
extension CategoryVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        let categoryName = category[indexPath.row]
        
        cell.configureBy(category: categoryName)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CategoryVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = category[indexPath.row]
        print("Category \(selectedCategory) is selected")
        
        let headLineVC = HeadlinesVC()
        headLineVC.category = self.category[indexPath.row]
        
        self.navigationController?.pushViewController(headLineVC, animated: true)
    }
}
