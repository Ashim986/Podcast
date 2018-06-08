//
//  ExtensionUserDefault.swift
//  Podcast
//
//  Created by ashim Dahal on 6/6/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let favoritesPodcastKey = "favoritesPodcastKey"
    func savedPodcasts() -> [Podcast] {
        
        guard let savedData = UserDefaults.standard.data(forKey: UserDefaults.favoritesPodcastKey) else {return []}
        guard let savedPoscasts = NSKeyedUnarchiver.unarchiveObject(with: savedData) as? [Podcast] else { return []}
        return savedPoscasts
    }
    
    func deletePodcast(podcast : Podcast){
        let podcasts = savedPodcasts()
        let filteredPodcast = podcasts.filter { (selectedPodcast) -> Bool in
            return podcast.trackName != selectedPodcast.trackName && podcast.artistName != selectedPodcast.artistName
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: filteredPodcast)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritesPodcastKey)
      
    }
}
