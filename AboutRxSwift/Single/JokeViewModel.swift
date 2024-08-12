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
        let text: Driver<Joke>
    }
    
    
    func transform(input: Input) -> Output {
//
//        let result = PublishSubject<String>()
        
        
//        input.tap
//            .flatMap{JokeNetwork.shared.fetchJoke()}
//            .subscribe(with: self) { owner, value in
//                result.onNext(value.joke)
//            }
//            .disposed(by: disposeBag)
        
        
       let result = input.tap
            .flatMap{
                JokeNetwork.shared.fetchJokeWithSingle()
                    .catch { error in
                        return Single<Joke>.just(Joke(joke: "rhkdus?", id: 0))
                    }
            }
            .asDriver(onErrorJustReturn: Joke(joke: "실패했을땐 이거임", id: 0))
        
        
        return Output(text: result)
    }
    
    
}
