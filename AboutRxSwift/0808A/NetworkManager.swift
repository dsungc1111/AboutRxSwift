//
//  NetworkManager.swift
//  AboutRxSwift
//
//  Created by 최대성 on 8/8/24.
//

import Foundation
import RxSwift


enum NetworkError: Error {
    case failedRequest
    case noData
    case invalidResponse
    case invalidData
    case invalidURL
}

struct DailyBoxOfficeList: Decodable {
    let movieNm: String
    let openDt: String
}
struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
    
}
struct Movie: Decodable {
    let boxOfficeResult: BoxOfficeResult
}


final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func callRequset(date: String) -> Single<Movie> {
        
        var component = URLComponents()
        component.scheme = "https"
        component.host = "kobis.or.kr"
        component.path = "/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
        component.queryItems = [
            URLQueryItem(name: "key", value: APIKey.key),
            URLQueryItem(name: "targetDt", value: date)
        ]
        
        let request = URLRequest(url: component.url!)
        
        let result = Single<Movie>.create { single in
         
            let aa: Movie = Movie(boxOfficeResult: BoxOfficeResult(dailyBoxOfficeList: [DailyBoxOfficeList(movieNm: "", openDt: "")]))
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard error == nil else {
                    print("error")
                    single(.success(aa))
                    return
                }
                guard let data = data else {
                    single(.failure(NetworkError.invalidData))
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    single(.failure(NetworkError.invalidResponse))
                    return
                }
                guard response.statusCode == 200 else {
                    single(.failure(NetworkError.invalidResponse))
                    return
                }
                
                if let appData = try? JSONDecoder().decode(Movie.self, from: data) {
//                    observer.onNext(appData)
//                    observer.onCompleted()
                    single(.success(appData))
                }
                
            }.resume()
                return Disposables.create()
            
        }
        
        return result
    }
    
    
}
