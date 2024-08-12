//
//  JokeNetwork.swift
//  AboutRxSwift
//
//  Created by 최대성 on 8/12/24.
//

import Foundation
import Alamofire
import RxSwift

struct Joke: Decodable {
    let joke: String
    let id: Int
}


final class JokeNetwork {
    
    static let shared = JokeNetwork()
    
    private init() {}
    
    func fetchJoke() -> Observable<Joke>{
        let jokeUrl = "https://v2.jokeapi.dev/joke/Programming?type=single"
        
        return Observable<Joke>.create { observer -> Disposable in
            
            
            AF.request(jokeUrl)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Joke.self) { response in
                    
                    switch response.result {
                    case .success(let success):
                        
                        observer.onNext(success)
                        observer.onCompleted() // 메모리 누수 방지
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            
            return Disposables.create()
        }.debug("조크 api 통신 singleXX")
    }
}

