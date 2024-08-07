//
//  ShoppingViewModel.swift
//  AboutRxSwift
//
//  Created by 최대성 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingViewModel {
    
    // 컬렉션뷰 세팅
    private var recommandedData = [
        "트랙패드", "키보드", "텀블러", "주스", "의자", "책상"
    ]
    
    
    
    
    // 테이블뷰 세팅
    private var data = [
        "과자", "떡", "삼겹살", "마우스", "아이패드", "아이폰"
    ]
    
//    private lazy var shoppingList = BehaviorRelay(value: data)
    
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        
        let searchText: ControlProperty<String?>
        let searchTap: ControlEvent<Void>
        let tapRec: ControlEvent<String>
    }
    
    struct Output {
        let searchResult: Observable<[String]>
        let shoppingList: BehaviorSubject<[String]> // 컬렉션뷰
        let recommandedList: BehaviorSubject<[String]>
        //          let searchTap: ControlEvent<Void>
    }
    
    struct CellInput {
        let completeTap: ControlEvent<Void>
        let isComplete: Bool
    }
    struct CellOutput {
        let btnImage: Observable<String>
    }
    
    
    func transform(input: Input) -> Output {
        
        // 테이블뷰
        let shoppingList = BehaviorSubject(value: data)
        let recommandedList = BehaviorSubject(value: recommandedData)
        
        let result = input.searchText.orEmpty
            .distinctUntilChanged()
        
        let filteredList = Observable.combineLatest(result, shoppingList) { result, list in
            result.isEmpty ? list : list.filter { $0.lowercased().contains(result.lowercased()) }
        }
        
        // 검색 후
        let buttonClicked = input.searchTap
        
        buttonClicked
            .withLatestFrom(result)
            .bind(with: self, onNext: { owner, value in
                owner.data.insert(value, at: 0)
                shoppingList.onNext(owner.data)
            })
            .disposed(by: disposeBag)
        
        
        
        
        
        // 컬렉션뷰
        let recommandedTap = input.tapRec
        
        recommandedTap
            .bind(with: self) { owner, value in
                owner.data.insert(value, at: 0)
                shoppingList.onNext(owner.data)
            }
            .disposed(by: disposeBag)
        
        
        return Output(searchResult: filteredList, shoppingList: shoppingList, recommandedList: recommandedList)
    }
    
    

}
