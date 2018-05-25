//
//  Epishod.swift
//  Podcast
//
//  Created by ashim Dahal on 5/20/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import Foundation
import FeedKit

struct Epishod {
    let title : String
    let pubDate : Date
    let description : String
    var imageUrl : String?
    init(feedItem : RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
    }
}

