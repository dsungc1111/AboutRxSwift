//
//  MovietableViewCell.swift
//  AboutRxSwift
//
//  Created by 최대성 on 8/8/24.
//

import UIKit
import SnapKit

final class MovietableViewCell: UITableViewCell {

    static let identifier = "MovietableViewCell"
    
    let movieTitle = UILabel()
    let realesedDate = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureLayout() {
        contentView.addSubview(movieTitle)
        contentView.addSubview(realesedDate)
        
        movieTitle.snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.width.equalTo(200)
        }
        
        
        realesedDate.snp.makeConstraints { make in
            make.trailing.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(movieTitle.snp.trailing).offset(10)
        }
        
    }
}
