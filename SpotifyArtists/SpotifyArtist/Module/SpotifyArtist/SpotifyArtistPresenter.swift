//
//  SpotifyArtistPresenter.swift
//  SpotifyArtist
//
//  Created by David Figueroa on 25/05/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import Foundation
import RxSwift

final class SpotifyArtistPresenter: SpotifyArtistPresenterProtocol {
    
    private let view: SpotifyViewProtocol
    private let interactor: SpotifyArtistInteractorProtocol
    
    private let disposeBag = DisposeBag()
    
    init(view: SpotifyViewProtocol, interactor: SpotifyArtistInteractorProtocol) {
        self.view = view
        self.interactor = interactor
        self.interactor.interactorOutputDelegate = self
    }
    
    func showArtists() {
        interactor.getArtists()
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] artistArray in
                self?.view.handlePresenterOutput(.showArtists(artistArray))
        }, onError: { [weak self] (error) in
            self?.view.handlePresenterOutput(.showArtists(self?.interactor.fetchLocalDataArtists() ?? [Artist]()))
        })
        .disposed(by: disposeBag)
    }
    
    func showDetailViewController(artist: Artist){
        App.router.launchDetailView(artist: artist)
    }
    
    func showAlbums(id: String) {
        interactor.getAlbums(id: id)
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] albumArray in
                self?.view.handlePresenterOutput(.showAlbums(albumArray))
        }, onError: { [weak self] (error) in
                self?.view.handlePresenterOutput(.showAlbums(self?.interactor.fetchLocalAlbums() ?? [Album]()))
        })
        .disposed(by: disposeBag)
    }
    
    func setAsFavorite(artist: Artist) {
        interactor.setAsFavorite(artist: artist)
    }
    
    func getFavorites() -> [Artist] {
        return interactor.getFavorites()
    }
    
    func isFavorite(artist: Artist) -> Bool {
        let artists = interactor.fetchLocalDataArtists()
        let isFavorite = artists.first(where: { $0.id == artist.id })?.isFavorite
        return isFavorite ?? false
    }
}

extension SpotifyArtistPresenter: SpotifyArtistInteractorDelegate{
    func handleInteractorOutput(_ output: HomeInteractorOutput) {
        switch output {
        case .showArtists( _):
//            view.handlePresenterOutput(.showSocialPosts(postArray))
            print("THIS TASK IS DONE BY RxSwift THIS DELEGATE IS LEFT HERE BECAUSE OF THE TECHNICAL TEST PURPOSES TO DISCUSS LATER.")
        }
    }
}

