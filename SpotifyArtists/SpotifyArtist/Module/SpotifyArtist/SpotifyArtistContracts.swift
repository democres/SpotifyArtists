//
//  SpotifyArtistContracts.swift
//  SpotifyArtist
//
//  Created by David Figueroa on 25/05/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - View
protocol SpotifyViewProtocol: class {
    func handlePresenterOutput(_ output: SpotifyPresenterOutput)
}

// MARK: - Interactor
protocol SpotifyArtistInteractorProtocol: class {
    var interactorOutputDelegate: SpotifyArtistInteractorDelegate? { get set }
    func getArtists() -> PublishSubject<[Artist]>
    func getAlbums(id: String) -> PublishSubject<[Album]>
    func fetchLocalData() -> [Artist]
    func fetchLocalAlbums() -> [Album]
}

protocol SpotifyArtistInteractorDelegate: class {
    func handleInteractorOutput(_ output: HomeInteractorOutput)
}

enum HomeInteractorOutput {
    case showArtists([Artist])
}

// MARK: - Presenter
protocol SpotifyArtistPresenterProtocol: class {
    func showArtists()
    func showDetailViewController(artist: Artist)
    func showAlbums(id: String)
}

enum SpotifyPresenterOutput {
    case showArtists([Artist])
    case showAlbums([Album])
}
