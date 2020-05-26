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

final class SpotifyArtistInteractor {
    
    weak var interactorOutputDelegate: SpotifyArtistInteractorDelegate?
    private(set) var disposeBag = DisposeBag()
    let apiService = APIService.shared
    
    var artistArray = PublishSubject<[Artist]>()
    var albumArray = PublishSubject<[Album]>()
}

extension SpotifyArtistInteractor: SpotifyArtistInteractorProtocol {
    
    func getArtists() -> PublishSubject<[Artist]> {
        apiService.getArtists()
            .subscribe { event in
                switch event {
                    case .success(let data):
                        self.artistArray.on(.next(self.mapArtists(data: data)))
                    case .error(let error):
                        print("Error: ", error)
                }
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
    
    func getAlbums(id: String) -> PublishSubject<[Album]> {
        apiService.getAlbums(id: id)
            .subscribe { event in
                switch event {
                    case .success(let data):
                        self.albumArray.on(.next(self.mapAlbums(data: data)))
                    case .error(let error):
                        print("Error: ", error)
                }
            }
        return albumArray
    }
    
    private func mapAlbums(data: Data) -> [Album] {
        let dataAux = try? JSONSerialization.jsonObject(with: data, options: [])
        if let json = dataAux as? [String: Any] {
            if let artists = json["items"] as? [[String: Any]] {
                if let albumArray = Mapper<Album>().mapArray(JSONObject: artists){
                    return albumArray
                }
            }
        }
        return fetchLocalAlbums()
    }
    
    func fetchLocalData() -> [Artist] {
        return [Artist]()
    }
    
    func fetchLocalAlbums() -> [Album] {
        return [Album]()
    }
    
}
