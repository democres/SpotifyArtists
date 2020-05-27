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
import RealmSwift

final class SpotifyArtistInteractor {
    
    weak var interactorOutputDelegate: SpotifyArtistInteractorDelegate?
    private(set) var disposeBag = DisposeBag()
    let apiService = APIService.shared
    
    var artistArray = PublishSubject<[Artist]>()
    var albumArray = PublishSubject<[Album]>()
}

extension SpotifyArtistInteractor: SpotifyArtistInteractorProtocol {
    
    func getFavorites() -> [Artist] {
        return fetchLocalDataArtists().filter{ $0.isFavorite }
    }
    
    func setAsFavorite(artist: Artist) {
        do {
            let realm = try Realm()
            try realm.write {
                artist.isFavorite = !artist.isFavorite
                realm.add(artist, update: .modified)
            }
        } catch let error {
            print(error)
        }
    }
    
    func getArtists() -> PublishSubject<[Artist]> {
        apiService.getArtists()
            .subscribe { event in
                switch event {
                    case .success(let data):
                        let artists = self.mapArtists(data: data)
                        self.storeData(artistArray: artists)
                        self.artistArray.on(.next(artists))
                    case .error(_):
                        self.artistArray.on(.next(self.fetchLocalDataArtists()))
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
        return fetchLocalDataArtists()
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
    
    func fetchLocalDataArtists() -> [Artist] {
        var artistArray = [Artist]()
        do {
            let realm = try Realm()
            realm.objects(Artist.self).forEach { artist in
                artistArray.append(artist)
            }
        } catch let error {
            print(error)
        }
        return artistArray
    }
    
    func fetchLocalAlbums() -> [Album] {
        return [Album]()
    }
    
    func storeData(artistArray: [Artist]){
        DispatchQueue.main.async {
            do {
                let realm = try Realm()
                let cacheArtists = self.fetchLocalDataArtists()
                try realm.write {
                    artistArray.forEach { artist in
                        if !cacheArtists.contains(where: { $0.id == artist.id }) {
                             realm.add(artist)
                        }
                    }
                }
            } catch let error {
                print(error)
            }
        }             

     }
     
}
