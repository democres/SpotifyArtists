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
        let viewController = SpotifyArtistBuilder.make()
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func launchDetailView(artist: Artist){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        viewController.artist = artist
        if let navigation = window?.rootViewController as? UINavigationController {
            navigation.pushViewController(viewController, animated: true)
        }
    }
}
