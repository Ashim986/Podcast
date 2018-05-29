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
    
    var podcasts = [Podcast]()
    var timer : Timer? // optional allow it to be nil at the begining of time
    let cellID = "cellID"
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
        // TODO:- remove this line when application finishes
        searchBar(searchController.searchBar, textDidChange: "Voong")
    }
    //MARK:- setup works
    fileprivate func setupTableView(){
        
        tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
    }
    
    //MARK:- SearchBar delegate methods
    
    fileprivate func setupSearchBar() {
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
    }

    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//     implement almofire to search itunes api upon text did change
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
                self.podcasts = podcasts
                self.tableView.reloadData()
            }
            
        })
        
    }
    
    // MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter a Search Term"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }
    
   
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //ternary operator
        return self.podcasts.count > 0 ? 0 : 250
    }
    
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let epishodController = EpishodController()
        epishodController.podcast = self.podcasts[indexPath.row]
        navigationController?.pushViewController(epishodController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let podcast = podcasts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PodcastCell
        cell.podcast = podcast
        
        return cell
    }
}
