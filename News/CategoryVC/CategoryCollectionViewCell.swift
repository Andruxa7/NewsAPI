//
//  CategoryCollectionViewCell.swift
//  News
//
//  Created by Andrii Stetsenko on 13.03.2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "categoryCell"
    
    // create nameLabel
    var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textAlignment = .center
        return lbl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true
        
        self.layer.cornerRadius = 9
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureBy(category: String) {
        switch category {
        case Category.general:
            self.backgroundColor = CategoryColor.generalColor.rawValue
        case Category.business:
            self.backgroundColor = CategoryColor.businessColor.rawValue
        case Category.science:
            self.backgroundColor = CategoryColor.scienceColor.rawValue
        case Category.technology:
            self.backgroundColor = CategoryColor.techColor.rawValue
        case Category.health:
            self.backgroundColor = CategoryColor.healthColor.rawValue
        case Category.entertainment:
            self.backgroundColor = CategoryColor.entertainColor.rawValue
        case Category.sports:
            self.backgroundColor = CategoryColor.sportsColor.rawValue
        default:
            self.backgroundColor = CategoryColor.generalColor.rawValue
        }
        
        self.nameLabel.text = category
        self.nameLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
}
