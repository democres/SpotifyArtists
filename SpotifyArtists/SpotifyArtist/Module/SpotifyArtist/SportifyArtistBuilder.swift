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
    static func make() -> HomeViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let interactor = SpotifyArtistHomeInteractor()
        let presenter = SpotifyArtistPresenter(view: view, interactor: interactor)
        view.presenter = presenter
        return view
    }
}
