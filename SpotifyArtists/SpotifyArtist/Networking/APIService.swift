//
//  APIService.swift
//  SpotifyArtist
//
//  Created by David Figueroa on 25/05/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class APIService {
    
    static var shared = APIService()
    lazy var requestObservable = RequestObservable(config: .default)
    
    let base64clientKey = "Basic ZDNkZDRkMzkzODQ0NDNmNGE2ZDZkYTdkMjliMzk3ZWY6YjAzZDIyYTQ3ZGJkNDg3NGI5Mjk3MWNlNjVjOTI2ODQ="
    
    func getBearerToken() -> Single<Data> {
        var request = URLRequest(url:
            URL(string:"https://accounts.spotify.com/api/token")!)
        request.httpMethod = "POST"
        
        //HEADER
        request.addValue(base64clientKey, forHTTPHeaderField:
        "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:
            "Content-Type")
        
        //BODY
        var bodyComponent = URLComponents()
        bodyComponent.queryItems = [URLQueryItem(name: "grant_type", value: "client_credentials")]
        request.httpBody = bodyComponent.query?.data(using: .utf8)
        
        return requestObservable.callAPI(request: request)
    }
    
    func getArtists() throws -> Single<Data> {
        var request = URLRequest(url:URL(string:"https://api.spotify.com/v1/artists?ids=4V8Sr092TqfHkfAA5fXXqG%2C6eUKZXaKkcviH0Ku9w2n3V%2C4VMYDCV2IEDYJArk749S6m%2C7Ln80lUS6He07XvHI8qqHH%2C12vb80Km0Ew53ABfJOepVz%2C7BFnoFhJjLWcsqmN3Hizqg%2C66NweiA3nU84k1S3SZdTSG%2C0EmeFodog0BfCgMzAIvKQp%2C0UWZUmn7sybxMCqrw9tGa7%2C6Ud6RjvNXVe39mKiGUb7zE%2C3IUAZiICL3J7GlHYPgT414%2C1f6CQnTy4FKDgLGzp6G2Wd%2C6n21XaDAuqpceTXBiypR9W%2C3OcvS8PzSGYMBvLdzY6g3e%2C0gudLEFCyMFIBCt1EQaMh7%2C3vjtBZfcllf1dc7lfyKKME%2C1zng9JZpblpk48IPceRWs8")!)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField:
            "Content-Type")
        request.addValue("Bearer \(App.bearerToken)", forHTTPHeaderField:
        "Authorization")
        return requestObservable.callAPI(request: request)
    }
    
}
