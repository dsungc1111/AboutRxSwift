//
//  ShoppingCollectionViewCell.swift
//  AboutRxSwift
//
//  Created by 최대성 on 8/7/24.
//

import UIKit

final class ShoppingCollectionViewCell: UICollectionViewCell {

    static let identifier = "ShoppingCollectionViewCell"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        
        contentView.addSubview(label)
        
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        label.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
