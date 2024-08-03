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
    private var data = [
        "과제제출", "RxSwift", "UIkit", "SwiftUI", "iOS", "macOS"
    ]
    
    private lazy var list = BehaviorRelay(value: data)
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        bind()
    }
    
    func bind() {
        
        
        list.bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
            cell.todoLabel.text = element
            }
            .disposed(by: disposeBag)
        
        
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                let result = value == "" ? owner.data : owner.data.filter { $0.contains(value)}
                owner.list.accept(result)
                print(value)
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
