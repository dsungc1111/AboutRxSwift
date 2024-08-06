//
//  ShoppintVC.swift
//  AboutRxSwift
//
//  Created by 최대성 on 8/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class ShoppingVC: UIViewController {
    
    
    private lazy var searchBar = {
        let bar = UISearchBar()
        bar.placeholder = "검색해주세요"
        return bar
    }()
    
    private lazy var tableView = {
        let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        return view
    }()
    
    private let viewModel = ShoppingViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        bind()
        
    }
    
    func bind() {
        let input = ShoppingViewModel.Input(searchText: searchBar.rx.text, searchTap: searchBar.rx.searchButtonClicked)
        
        let output = viewModel.transform(input: input)


        output.searchResult
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
                
                cell.completeButton.rx.tap
                    .bind(with: self) { owner, _ in
                        cell.isComplete.toggle()
                        
                        let image = cell.isComplete ? "checkmark.square.fill" : "checkmark.square"
                        cell.completeButton.setImage(UIImage(systemName: image), for: .normal)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.bookmarkButton.rx.tap
                    .bind(with: self) { owner, _ in
                        cell.isBookmark.toggle()
                        
                        let image = cell.isBookmark ? "star.fill" : "star"
                        cell.bookmarkButton.setImage(UIImage(systemName: image), for: .normal)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.todoLabel.text = element
                }
                .disposed(by: disposeBag)
     
    }
    
    func configureLayout() {
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(250)
        }
    }
}
