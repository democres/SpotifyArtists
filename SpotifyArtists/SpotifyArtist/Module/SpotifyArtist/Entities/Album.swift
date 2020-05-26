//
//  Album.swift
//  SpotifyArtist
//
//  Created by David Figueroa on 26/05/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import ObjectMapper
import RealmSwift

class Album: Object, Mappable, Decodable {

    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var smallImage: String?
    @objc dynamic var fullImage: String?
    @objc dynamic var releaseDate: String?
    @objc dynamic var totalTracks: Int = 0
    @objc dynamic var url: String? {
        return "https://open.spotify.com/album/\(id ?? "")"
    }
    
    //MARK: - Mappable
    required convenience init?(map: Map) {
          self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        smallImage <- map["images.2.url"]
        fullImage <- map["images.0.url"]
        releaseDate <- map["release_date"]
        totalTracks <- map["total_tracks"]
    }
    
}
