//
//  Podcast.swift
//  Podcast
//
//  Created by ashim Dahal on 4/22/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import Foundation

struct Podcast : Decodable {
    var trackName : String?
    var artistName : String?
    var artworkUrl600 : String?
    var trackCount : Int?
    var feedUrl : String?
}


