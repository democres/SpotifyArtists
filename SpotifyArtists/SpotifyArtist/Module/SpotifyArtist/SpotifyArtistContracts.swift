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
protocol HomeViewProtocol: class {
    func handlePresenterOutput(_ output: HomePresenterOutput)
}

// MARK: - Interactor
protocol SpotifyArtistInteractorProtocol: class {
    var interactorOutputDelegate: SpotifyArtistInteractorDelegate? { get set }
    func getArtists(index: Int) -> PublishSubject<[Artist]>
    func fetchLocalData() -> [Artist]
}

protocol SpotifyArtistInteractorDelegate: class {
    func handleInteractorOutput(_ output: HomeInteractorOutput)
}

enum HomeInteractorOutput {
    case showArtists([Artist])
}

// MARK: - Presenter
protocol SpotifyArtistPresenterProtocol: class {
    func showArtist(index: Int)
    func showDetailViewController(artist: Artist)
}

enum HomePresenterOutput {
    case showArtists([Artist])
}
