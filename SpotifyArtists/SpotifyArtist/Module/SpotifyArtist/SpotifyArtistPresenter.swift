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
    
    private let view: HomeViewProtocol
    private let interactor: SpotifyArtistInteractorProtocol
    
    private let disposeBag = DisposeBag()
    
    init(view: HomeViewProtocol, interactor: SpotifyArtistInteractorProtocol) {
        self.view = view
        self.interactor = interactor
        self.interactor.interactorOutputDelegate = self
    }
    
    
    func showArtist(index: Int) {
        interactor.getArtists(index: index)
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] artistArray in
                self?.view.handlePresenterOutput(.showArtists(artistArray))
        }, onError: { [weak self] (error) in
            self?.view.handlePresenterOutput(.showArtists(self?.interactor.fetchLocalData() ?? [Artist]()))
        })
        .disposed(by: disposeBag)
    }
    
}

extension SpotifyArtistPresenter: SpotifyArtistInteractorDelegate{
    func handleInteractorOutput(_ output: HomeInteractorOutput) {
        switch output {
        case .showArtists(let _):
//            view.handlePresenterOutput(.showSocialPosts(postArray))
            print("THIS TASK IS DONE BY RxSwift THIS DELEGATE IS LEFT HERE BECAUSE OF THE TECHNICAL TEST PURPOSES TO DISCUSS LATER.")
        }
    }
}

