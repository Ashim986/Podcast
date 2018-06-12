//
//  DownloadController.swift
//  Podcast
//
//  Created by ashim Dahal on 6/8/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit

class DownloadController: UITableViewController {
    let cellID = "CellID"
    
    var episodes = UserDefaults.standard.savedDownloadedEpishod()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.episodes = UserDefaults.standard.savedDownloadedEpishod()
        tableView.reloadData()
        UIApplication.mainTabBarController()?.viewControllers?[2].tabBarItem.badgeValue = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupObserver()
    }
    
    
    fileprivate func setupTableView() {
        let epishodNib = UINib(nibName: "EpishodCell", bundle: nil)
        tableView.register(epishodNib, forCellReuseIdentifier: cellID)
        
    }
    
    fileprivate func setupObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadComplete, object: nil)
        
    }
    
    
    @objc fileprivate func handleDownloadProgress(notification : Notification){
        
        guard let userInfo = notification.userInfo as? [String : Any] else {return}
        guard let progress = userInfo["progress"] as? Double else {return}
        guard let title = userInfo["title"] as? String else {return}
        guard let index = self.episodes.index(where: { $0.title == title }) else { return }
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpishodCell else { return }
        cell.downloadPercentage.text = "\(Int(progress * 100))%"
        cell.downloadPercentage.isHidden = false
        if progress == 1 {
            cell.downloadPercentage.isHidden = true
        }
        
    }
    
    @objc fileprivate func handleDownloadComplete(notification : Notification){
        
        guard let episodeDownloadComplete = notification.object as? APIService.downloadCompleteTuple else {return}
        guard let index = self.episodes.index(where : {
            $0.title == episodeDownloadComplete.episodeTitle
        }) else {return}
        self.episodes[index].fileUrl = episodeDownloadComplete.fileUrl
      
    }
    
    // MARK:- TableView
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
           
            UserDefaults.standard.deleteDownloadedEpisode(episode: self.episodes[indexPath.row])
            self.episodes = UserDefaults.standard.savedDownloadedEpishod()
            tableView.reloadData()
        }
        
       return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        let episode = episodes[indexPath.row]
        if episode.fileUrl != nil {
           UIApplication.mainTabBarController()?.maximizePlayerDetails(epishod: episode)
        }else{
            let alertController = UIAlertController(title: "File URL Not Found", message: "cannot find local file please play using stream url", preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                UIApplication.mainTabBarController()?.maximizePlayerDetails(epishod: episode)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EpishodCell
        cell.epishod = episodes[indexPath.row]
        return cell
    }
    
    
}
