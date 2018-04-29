//
//  SearchController.swift
//  Podcast
//
//  Created by ashim Dahal on 4/22/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
    
    let dummyPodcasts = [
        Podcast(name: "Lets build that app", artistName: "Brian Voong"),
        Podcast(name: "This is my app", artistName: "Ashim Dahal")
    ]
    let cellID = "cellID"
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
    }
    
    //MARK:- SearchBar delegate methods
    
    fileprivate func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print(searchText)
        
    // implement almofire to search itunes api upon text did change
        let url = "https://yahoo.com"
        Alamofire.request(url).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to connect to yahoo.com", err)
            return
            }
            
            guard let data = dataResponse.data else {return}
            
            let dummyString = String(data: data, encoding: .utf8)
            print(dummyString ?? "")
            
        }
        
    }
 
    // MARK:- UITableView
    
    fileprivate func setupTableView(){
        tableView.register(UITableViewCell.self , forCellReuseIdentifier: cellID)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyPodcasts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let podcast = dummyPodcasts[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellID)
        
        cell.textLabel?.text = podcast.name
        cell.detailTextLabel?.text = podcast.artistName
        cell.imageView?.image = #imageLiteral(resourceName: "appicon")
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
}
