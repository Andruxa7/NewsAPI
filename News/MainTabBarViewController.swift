//
//  MainTabBarViewController.swift
//  News
//
//  Created by Andrii Stetsenko on 06.02.2024.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
                
        let vc1 = UINavigationController(rootViewController: HeadlinesVC())
        let vc2 = UINavigationController(rootViewController: CategoryVC())
        
        // Add icons
        vc1.tabBarItem.image = UIImage(systemName: "house")
        let categoryImage = UIImage(named: "category")
        vc2.tabBarItem.image = categoryImage?.imageResized(to: CGSize(width: 30, height: 30))
        

        // Add titles
        vc1.title = "Top News"
        vc2.title = "Categories"
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1, vc2], animated: true)
    }
}
