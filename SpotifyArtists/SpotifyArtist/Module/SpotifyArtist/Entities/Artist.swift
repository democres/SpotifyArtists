//
//  Artist.swift
//  SpotifyArtist
//
//  Created by David Figueroa on 25/05/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//
import ObjectMapper
import RealmSwift

class Artist: Object, Mappable, Decodable {

    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var profileImage: String?
    @objc dynamic var fullImage: String?
    @objc dynamic var popularity: Int = 0
    @objc dynamic var followers: Int = 0
    @objc dynamic var genres: [String]?
    @objc dynamic var isFavorite: Bool = false
    @objc dynamic var url: String? {
        return "https://open.spotify.com/artist/\(id ?? "")"
    }
    
    
    
    //MARK: - Mappable
    required convenience init?(map: Map) {
          self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        profileImage <- map["images.2.url"]
        fullImage <- map["images.0.url"]
        popularity <- map["popularity"]
        followers <- map["followers.total"]
        genres <- map["genres"]
    }
    
}
