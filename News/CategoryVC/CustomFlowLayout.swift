//
//  CustomFlowLayout.swift
//  News
//
//  Created by Andrii Stetsenko on 14.03.2024.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let totalWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        let itemsPerRow: CGFloat = 2
        let padding: CGFloat = 20
        let minimumItemSpacing: CGFloat = 5
        let availableWidth = totalWidth - (padding * 2) - minimumItemSpacing
    
        let cellWidth = (availableWidth / itemsPerRow)
        
        self.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.itemSize = CGSize(width: cellWidth, height: cellWidth)
        self.sectionInsetReference = .fromSafeArea
    }
    
}
