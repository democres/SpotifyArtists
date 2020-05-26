//
//  AppRouter.swift
//  SpotifyArtist
//
//  Created by David Figueroa on 25/05/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import Foundation
import Foundation
import UIKit

final class AppRouter {
    var window: UIWindow?
    
    func launchHomeFeed(){
        let viewController = SpotifyArtistBuilder.makeHomeViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func launchDetailView(artist: Artist){
        let viewController = SpotifyArtistBuilder.makeDetailViewController(artist: artist)
        if let navigation = window?.rootViewController as? UINavigationController {
            navigation.pushViewController(viewController, animated: true)
        }
    }
}
