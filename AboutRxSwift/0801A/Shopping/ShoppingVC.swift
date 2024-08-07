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
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout() )
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
    
    private let viewModel = ShoppingViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        bind()
        
    }
    
    func bind() {
        
       
        
        let input = ShoppingViewModel.Input(searchText: searchBar.rx.text, searchTap: searchBar.rx.searchButtonClicked, tapRec: collectionView.rx.modelSelected(String.self))
        
        let output = viewModel.transform(input: input)

        // 컬렉션뷰
        output.recommandedList
            .bind(to: collectionView.rx.items(cellIdentifier: ShoppingCollectionViewCell.identifier, cellType: ShoppingCollectionViewCell.self)) { (row, element, cell) in
                
                cell.label.text = element
                
            }
            .disposed(by: disposeBag)
        
        
        
        
        
        
        output.shoppingList
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) {  (row, element, cell) in
                
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
        view.addSubview(collectionView)
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(60)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(60)
        }
        collectionView.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingCollectionViewCell.identifier)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(30)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            
        }
    }
}
