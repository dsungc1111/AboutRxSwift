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
    
   
   private let disposeBag = DisposeBag()
    
    struct Input {
        let list: BehaviorRelay<[String]>
        let searchText: ControlProperty<String?>
        let searchTap: ControlEvent<Void>
    }
    struct Output {
          let searchResult: Observable<[String]>
          let searchTap: ControlEvent<Void>
      }
      
      func transform(input: Input) -> Output {
          let list = input.list
          let result = input.searchText.orEmpty
              .debounce(.seconds(1), scheduler: MainScheduler.instance)
              .distinctUntilChanged()
          
          let filteredText = Observable.combineLatest(result, list) { result, list in
              result.isEmpty ? list : list.filter { $0.contains(result) }
          }
          

          return Output(searchResult: filteredText, searchTap: input.searchTap)
      }
    
}
