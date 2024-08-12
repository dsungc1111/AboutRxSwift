//
//  MovieViewModel.swift
//  AboutRxSwift
//
//  Created by 최대성 on 8/8/24.
//

import Foundation
import RxSwift
import RxCocoa

class MovieViewModel {
    
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let searchTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
    }
    struct Output {
        let movieList: Driver<[DailyBoxOfficeList]>
    }
    
    
    func transform(input: Input) -> Output {
        
//        var topMovies = PublishSubject<[DailyBoxOfficeList]>()
        
        let topMovies = input.searchTap
//            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map {
                guard let intText = Int($0) else {
                    return 20240701
                }
                return intText
            }
            .map { return "\($0)" }
            .flatMap { value in
                NetworkManager.shared.callRequset(date: value)
            }
            .map { value in
                value.boxOfficeResult.dailyBoxOfficeList
            }
//            .subscribe(with: self, onNext: { owner, value in
////                topMovies.onNext(value.boxOfficeResult.dailyBoxOfficeList)
//                
//
//            })
//            .disposed(by: disposeBag)
            .asDriver(onErrorJustReturn:  [DailyBoxOfficeList(movieNm: "아니야 ", openDt: "제발")])
        
        return Output(movieList: topMovies)
    }
}
