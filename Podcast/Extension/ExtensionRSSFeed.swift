//
//  ExtensionRSSFeed.swift
//  Podcast
//
//  Created by ashim Dahal on 5/22/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import Foundation
import FeedKit

extension RSSFeed {
    func toEpishod() -> [Epishod] {
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        var episodes = [Epishod]()
        items?.forEach({ (feedItem) in
            var epishod = Epishod(feedItem: feedItem)
            if epishod.imageUrl == nil{
                epishod.imageUrl = imageUrl
            }
            episodes.append(epishod)
        })
        
        return episodes
    }
    
}
