//
//  Podcast.swift
//  Podcast
//
//  Created by ashim Dahal on 4/22/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import Foundation

class Podcast : NSObject ,Decodable , NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(trackName ?? "", forKey: "trackNameKey")
        aCoder.encode(artistName ?? "", forKey: "artistNameKey")
        aCoder.encode(artworkUrl600 ?? "", forKey: "artWorkImageURLKey")
        aCoder.encode(feedUrl ?? "", forKey: "feedURLKey")
    }
    required init?(coder aDecoder: NSCoder) {
        self.trackName = aDecoder.decodeObject(forKey: "trackNameKey") as? String
        self.artistName = aDecoder.decodeObject(forKey: "artistNameKey") as? String
        self.artworkUrl600 = aDecoder.decodeObject(forKey: "artWorkImageURLKey") as? String
        self.feedUrl = aDecoder.decodeObject(forKey: "feedURLKey") as? String
    }
    
    var trackName : String?
    var artistName : String?
    var artworkUrl600 : String?
    var trackCount : Int?
    var feedUrl : String?
}


