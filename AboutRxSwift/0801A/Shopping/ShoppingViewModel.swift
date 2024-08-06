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
    
    
    private var data = [
        "과제제출", "RxSwift", "UIkit", "SwiftUI", "iOS", "macOS"
    ]
    
    private lazy var shoppingList = BehaviorRelay(value: data)
    
   
   private let disposeBag = DisposeBag()
    
    struct Input {
//        let list: BehaviorRelay<[String]>
        let searchText: ControlProperty<String?>
        let searchTap: ControlEvent<Void>
    }
    
    struct Output {
          let searchResult: Observable<[String]>
        
//          let searchTap: ControlEvent<Void>
      }
    
      func transform(input: Input) -> Output {
          
          let result = input.searchText.orEmpty
              .debounce(.seconds(1), scheduler: MainScheduler.instance)
              .distinctUntilChanged()
          
          var filteredList = Observable.combineLatest(result, shoppingList) { result, list in
              result.isEmpty ? list : list.filter { $0.lowercased().contains(result.lowercased()) }
          }
          print(filteredList)
          //MARK: - 검색어 처리
          // 상황에 맞게
          // case 1. 최근검색어로 사용 > 이전 기록 삭제 후, 가장 상단으로 배치
          // case 2. todo로 이용 시, 굳이 상단으로 올릴 필요없으니 중복시 추가 XX
          
          let buttonClicked = input.searchTap
          
          buttonClicked
              .withLatestFrom(result)
              .bind(with: self, onNext: { owner, value in
                  
                
                  owner.data.insert(value, at: 0)
                  owner.shoppingList.accept(owner.data)
              })
              .disposed(by: disposeBag)
          
          return Output(searchResult: filteredList)
      }
    
}
