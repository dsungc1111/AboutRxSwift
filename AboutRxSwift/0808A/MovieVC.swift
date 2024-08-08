//
//  MovieVC.swift
//  AboutRxSwift
//
//  Created by 최대성 on 8/8/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MovieVC: UIViewController {

    private let movieView = MovieView()
    
    private let viewModel = MovieViewModel()
    private let disposeBag = DisposeBag()
    override func loadView() {
        view = movieView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bind()
        movieView.tableView.register(MovietableViewCell.self, forCellReuseIdentifier: MovietableViewCell.identifier)
    }
    
    func bind() {
        
        let input = MovieViewModel.Input(searchTap: movieView.searchBar.rx.searchButtonClicked, searchText: movieView.searchBar.rx.text.orEmpty )
        
        let a = movieView.searchBar.rx.text
        let output = viewModel.transform(input: input)
        
        output.movieList
            .bind(to: movieView.tableView.rx.items(cellIdentifier: MovietableViewCell.identifier, cellType: MovietableViewCell.self)) {
                (row, element, cell) in
                
                cell.movieTitle.text = element.movieNm
                cell.realesedDate.text = element.openDt
            }
            .disposed(by: disposeBag)
    }
}
