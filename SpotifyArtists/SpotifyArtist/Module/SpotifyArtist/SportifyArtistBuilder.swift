//
//  SportifyArtistBuilder.swift
//  SpotifyArtist
//
//  Created by David Figueroa on 25/05/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import Foundation
import UIKit

final class SpotifyArtistBuilder {
    static func makeHomeViewController() -> HomeViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let interactor = SpotifyArtistInteractor()
        let presenter = SpotifyArtistPresenter(view: view, interactor: interactor)
        view.presenter = presenter
        return view
    }
    
    static func makeDetailViewController(artist: Artist) -> DetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let interactor = SpotifyArtistInteractor()
        let presenter = SpotifyArtistPresenter(view: view, interactor: interactor)
        view.presenter = presenter
        view.artist = artist
        return view
    }
}
