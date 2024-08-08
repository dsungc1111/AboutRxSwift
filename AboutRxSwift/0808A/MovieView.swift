//
//  MovieView.swift
//  AboutRxSwift
//
//  Created by 최대성 on 8/8/24.
//

import UIKit
import SnapKit


final class MovieView: UIView {
    
    let searchBar = UISearchBar()
    
    let tableView = UITableView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        addSubview(searchBar)
        addSubview(tableView)
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        tableView.backgroundColor = .lightGray
    }
}
