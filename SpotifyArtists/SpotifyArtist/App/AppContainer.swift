//
//  AppContainer.swift
//  SpotifyArtist
//
//  Created by David Figueroa on 25/05/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

let App = AppContainer()

final class AppContainer {
    let router = AppRouter()
    var bearerToken = ""
    let disposeBag = DisposeBag()
    
    init() {
        let apiService = APIService.shared
        
        apiService.getBearerToken()
            .subscribeOn(GCDQueues.serialInteractive)
            .observeOn(GCDQueues.main)
            .subscribe { event in
                switch event {
                case .success(let data):
                    let dataAux = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let json = dataAux as? [String: Any] {
                        self.bearerToken = (json["access_token"] as? String ?? "")
                    }
                case .error(let error):
                    print("Error: ", error)
                }
            }
            .disposed(by: disposeBag)
                
    }
    
}
