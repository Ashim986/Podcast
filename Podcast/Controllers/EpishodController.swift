//
//  EpishodController.swift
//  Podcast
//
//  Created by ashim Dahal on 5/17/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit
import FeedKit

class EpishodController: UITableViewController {
    var podcast : Podcast? {
        didSet{
            navigationItem.title = podcast?.trackName
            fetchEpishod()
        }
    }
    
    fileprivate func fetchEpishod(){
        guard let feedUrl = podcast?.feedUrl else {return}
        APIService.shared.fetchEpishod(feedUrl: feedUrl) { (epishods) in
            self.epishods = epishods
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return epishods.isEmpty ? 200 : 0
    }
    
    var epishods = [Epishod]()
    
    private let cellID = "cellID"
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    //MARK:- setup Views
    fileprivate func setupTableView(){
        let nib = UINib(nibName: "EpishodCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
    }
    
    
    //MARK:- UitableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return epishods.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let epishod = epishods[indexPath.row]
        UIApplication.mainTabBarController()?.maximizePlayerDetails(epishod: epishod, playlistEpishods : self.epishods)

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EpishodCell
        let epishod = epishods[indexPath.row]
        cell.epishod = epishod 
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
        
    }
    
}
