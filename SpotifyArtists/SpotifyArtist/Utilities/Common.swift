//
//  Common.swift
//  SpotifyArtist
//
//  Created by David Figueroa on 25/05/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

final class CommonUtilities{
    static func getFollowers(number: Int) -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = ","
        formater.numberStyle = .decimal
        let formattedNumber = formater.string(from: NSNumber(value: number))
        
        return "Followers: \(formattedNumber ?? "")"
    }
    
    static func setupImage(imageUrl: String, imageView: UIImageView, placeholder: String){
        let url = URL(string: imageUrl)
        imageView.kf.setImage(
        with: url,
        placeholder: UIImage(named: placeholder),
        options: [
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ])
    }
    
}

// MARK: - SAFE ACCESS TO COLLECTIONS
extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
