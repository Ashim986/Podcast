//
//  ViewController.swift
//  Podcast
//
//  Created by ashim Dahal on 3/29/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var maximizedTopAnchorConstraint : NSLayoutConstraint!
    var minimizedTopAnchorConstraint : NSLayoutConstraint!
    var bottomAnchorConstraint : NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple
        setupViewControllers()
        setupPlayerDetailView()
    
    }
    
    @objc func  minimizePlayerDetails(){
        
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
       
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
           
            self.tabBar.transform = .identity
            self.view.layoutIfNeeded()
            self.playerDetailView.maximizedStackView.alpha = 0
            self.playerDetailView.miniPlayerView.alpha = 1
        })
    
    }
    
    func maximizePlayerDetails(epishod : Epishod? , playlistEpishods : [Epishod] = []) {
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
         
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            self.view.layoutIfNeeded()
            self.playerDetailView.maximizedStackView.alpha = 1
            self.playerDetailView.miniPlayerView.alpha = 0
        })
        if epishod != nil {
             playerDetailView.epishod = epishod
        }
        playerDetailView.playlistEpishod = playlistEpishods
      
    }
    
    //MARK:- SetupFunctions
     let playerDetailView = PlayerDetailView.initFromNib()
    
    fileprivate func setupPlayerDetailView(){
  
        view.addSubview(playerDetailView)
        view.insertSubview(playerDetailView, belowSubview: tabBar)
        playerDetailView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchorConstraint = playerDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true
        bottomAnchorConstraint = playerDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant : view.frame.height)
        bottomAnchorConstraint.isActive = true
        
        minimizedTopAnchorConstraint =  playerDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor , constant : -64)
//        minimizedTopAnchorConstraint.isActive = true
    
        playerDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
   
    }
    
 
    
    fileprivate func setupViewControllers(){
        
            let layout = UICollectionViewFlowLayout()
        let favoritesController = generateNavigationController(with: FavoritesController(collectionViewLayout: layout), title: "Favorites", image: #imageLiteral(resourceName: "favorites"))
        let searchNavController = generateNavigationController(with: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search"))
        let downloadNavController = generateNavigationController(with: FavoritesController(), title: "Download", image: #imageLiteral(resourceName: "downloads"))
        viewControllers = [searchNavController, favoritesController, downloadNavController]
    }
    
    
    //MARK:- Helper Functions
    
    fileprivate func generateNavigationController(with rootViewController: UIViewController, title : String, image : UIImage)->UINavigationController{
        
        let navController = UINavigationController(rootViewController: rootViewController)
       
//        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        return navController
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

