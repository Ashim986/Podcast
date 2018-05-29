//
//  ServiceAPI.swift
//  Podcast
//
//  Created by ashim Dahal on 4/29/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    
    // singlton
    static let shared = APIService()
    let baseItunesSearchURL = "https://itunes.apple.com/search"
    
    func fetchPodcasts(searchText : String , completionHandler : @escaping ([Podcast]) -> () ){
        let paramaters = ["term": searchText , "media" : "podcast"]
        Alamofire.request(baseItunesSearchURL, method: .get, parameters: paramaters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            
            if let err = dataResponse.error {
                print("failed to connect to itunes service", err)
            }
            
            guard let data = dataResponse.data else {return}
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
              completionHandler(searchResult.results)
                
            }catch let JSONErr {
                print("failed to get Json data", JSONErr)
            }
        }
    }
    
    
    func fetchEpishod(feedUrl : String , completionHandler : @escaping ([Epishod]) ->())  {
        
        
        let secureFeedUrl = feedUrl.toSecureHTTPS()
        guard let url = URL(string: secureFeedUrl) else {return}
        let parser = FeedParser(URL: url)
        parser?.parseAsync(result: { (result) in
            
            if let err = result.error {
                print("failed to parse XML Feed :", err)
                return
            }
            guard let feed = result.rssFeed else {return}
            
            let epishods = feed.toEpishod()
            completionHandler(epishods)

        })
        
        
        
        
    }
    
}

struct SearchResults : Decodable {
    let resultCount : Int
    let results : [Podcast]
}