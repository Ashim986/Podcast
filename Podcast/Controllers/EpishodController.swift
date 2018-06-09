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

    private let cellID = "cellID"
 
    var epishods = [Epishod]()
    
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
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBarButton()
    }

    //MARK:- setup Views
    fileprivate func setupTableView(){
        let nib = UINib(nibName: "EpishodCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
    }

    fileprivate func setupNavigationBarButton(){
        // chk if already favorited
        
        let savedPodcasts = UserDefaults.standard.savedPodcasts()
        
        let hasFavorited =  savedPodcasts.index(where: { (favoritePodcast) -> Bool in
            return (favoritePodcast.trackName == self.podcast?.trackName && favoritePodcast.artistName == self.podcast?.artistName)
        }) != nil
        
        if hasFavorited {
            // setup heart item
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart") , style: .plain, target: nil, action: nil)
            
        }else {
            
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite)),
            ]
        }

    }
    
    @objc fileprivate func handleSaveFavorite(){
        
        guard let podcast = podcast else {return}
        
        // 1. transform podcast into Data
        
        var listOfPodcasts = UserDefaults.standard.savedPodcasts()
        listOfPodcasts.append(podcast)
        let data = NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritesPodcastKey)
        
        showBatchHighlight()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
        
    }

    fileprivate func showBatchHighlight() {
        
        let mainTabBarController = UIApplication.mainTabBarController()
        mainTabBarController?.viewControllers?[1].tabBarItem.badgeValue = "New"
        
    }
    
    //MARK:- UitableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return epishods.count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let downloadController = DownloadController()
        let hasDownloaded = downloadController.episodes.contains { (downloadEpisode) -> Bool in
            return downloadEpisode.title == self.epishods[indexPath.row].title
        }
        if !hasDownloaded {
            UIApplication.mainTabBarController()?.viewControllers?[2].tabBarItem.badgeValue = "New"
        }else {
            UIApplication.mainTabBarController()?.viewControllers?[2].tabBarItem.badgeValue = nil
        }
        
        let downloadAction = UITableViewRowAction(style: .normal, title: "Download") { (_, _) in
            
            let episode = self.epishods[indexPath.row]
            UserDefaults.standard.downloadEpisode(episode: episode)
        
            APIService.shared.downloadEpisode(episode: episode)
        }
      
        return [downloadAction]
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
