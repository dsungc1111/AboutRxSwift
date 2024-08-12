//
//  JokeViewModel.swift
//  AboutRxSwift
//
//  Created by 최대성 on 8/12/24.
//

import Foundation
import RxSwift
import RxCocoa

final class JokeViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let tap: ControlEvent<Void>
    }
    struct Output {
        let text: PublishSubject<String>
    }
    
    
    func transform(input: Input) -> Output {
        
        let result = PublishSubject<String>()
        
        input.tap
            .flatMap{JokeNetwork.shared.fetchJoke()}
            .subscribe(with: self) { owner, value in
                result.onNext(value.joke)
            }
            .disposed(by: disposeBag)
        
        
        return Output(text: result)
    }
    
}
