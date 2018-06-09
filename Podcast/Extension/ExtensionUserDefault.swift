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
    static let downloadEpisodeKey = "downloadEpisodeKey"
    
    
    func downloadEpisode(episode : Epishod) {
        do {
            var listOfDownloadedEpisode = savedDownloadedEpishod()
            let hasDownloadedEpisodes = listOfDownloadedEpisode.contains { (savedepisode) -> Bool in
              return (savedepisode.title == episode.title && savedepisode.author == episode.author)
            }
            
            if listOfDownloadedEpisode.isEmpty || !hasDownloadedEpisodes {
                listOfDownloadedEpisode.append(episode)
                let data = try JSONEncoder().encode(listOfDownloadedEpisode)
                UserDefaults.standard.setValue(data, forKey: UserDefaults.downloadEpisodeKey)
            }
         
        }catch let  encoderErr {
            print("Failed to encode Data", encoderErr)
        }
        
    }
    
    func savedDownloadedEpishod() -> [Epishod] {
        
        guard let episodeData = UserDefaults.standard.data(forKey: UserDefaults.downloadEpisodeKey) else { return [] }
        do  {
            let savedEpisodes = try JSONDecoder().decode([Epishod].self, from: episodeData)
            return savedEpisodes
            
        }catch let  decodeErr {
            print("Failed to decode saved episode", decodeErr)
        }
     
        return []
    }
    
    func deleteDownloadedEpisode(episode : Epishod)  {
        let downloadedEpisodes = savedDownloadedEpishod()
        let filteredEpisodes = downloadedEpisodes.filter { (selectedEpisode) -> Bool in
            return (selectedEpisode.title != episode.title)
        }
        
        do {
            let filteredDownloadedEpisodes = try JSONEncoder().encode(filteredEpisodes)
            UserDefaults.standard.setValue(filteredDownloadedEpisodes, forKey: UserDefaults.downloadEpisodeKey)
            
        }catch let encodedErr {
            print("failed to encode data ", encodedErr)
        }
       
    }
    
    
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
