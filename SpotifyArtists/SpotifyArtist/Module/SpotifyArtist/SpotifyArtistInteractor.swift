//
//  SpotifyAritstHomeInteractor.swift
//  SpotifyArtist
//
//  Created by David Figueroa on 25/05/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

final class SpotifyArtistHomeInteractor {
    
    weak var interactorOutputDelegate: SpotifyArtistInteractorDelegate?
    private(set) var disposeBag = DisposeBag()
    let apiService = APIService.shared
    
    var artistArray = PublishSubject<[Artist]>()
}

extension SpotifyArtistHomeInteractor: SpotifyArtistInteractorProtocol {
    
    func getArtists(index: Int) -> PublishSubject<[Artist]> {
        do{
            try apiService.getArtists()
            .subscribe { event in
                switch event {
                    case .success(let data):
                        self.artistArray.on(.next(self.mapArtists(data: data)))
                    case .error(let error):
                        print("Error: ", error)
                }
            }
        }
        catch{
            print("Error while fetching data")
        }
        return artistArray
    }
    
    private func mapArtists(data: Data) -> [Artist] {
        let dataAux = try? JSONSerialization.jsonObject(with: data, options: [])
        if let json = dataAux as? [String: Any] {
            if let artists = json["artists"] as? [[String: Any]] {
                if let artistArray = Mapper<Artist>().mapArray(JSONObject: artists){
                    return artistArray
                }
            }
        }
        return fetchLocalData()
    }
    
    
    func fetchLocalData() -> [Artist] {
        return [Artist]()
    }
    
}
