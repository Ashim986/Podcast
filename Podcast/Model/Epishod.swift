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
    let author : String?
    let streamUrl : String
    init(feedItem : RSSFeedItem) {
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
    }
}

