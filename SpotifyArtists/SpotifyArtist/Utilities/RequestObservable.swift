//
//  RequestObservable.swift
//  SpotifyArtist
//
//  Created by David Figueroa on 25/05/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import Foundation
import RxSwift

public class RequestObservable {
    private lazy var jsonDecoder = JSONDecoder()
    private var urlSession: URLSession
    public init(config:URLSessionConfiguration) {
        urlSession = URLSession(configuration:
            URLSessionConfiguration.default)
    }
    //MARK: function for URLSession
    func callAPI(request: URLRequest) -> Single<Data> {
        return Single<Data>.create { single in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    single(.error(error))
                    return
                }
                
                guard let data = data else {
                    let error = NSError(domain:"ErrorFetchingData", code:500, userInfo:nil)
                    single(.error(error))
                    return
                }
                
                single(.success(data))
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
        
}
