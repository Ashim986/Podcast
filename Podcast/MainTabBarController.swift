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
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple
        setupViewControllers()
        setupPlayerDetailView()
    
    }
    
    @objc func  minimizePlayerDetails(){
        
        maximizedTopAnchorConstraint.isActive = false
        minimizedTopAnchorConstraint.isActive = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
           
            self.tabBar.transform = .identity
            self.view.layoutIfNeeded()
        })
    
    }
    
    func maximizePlayerDetails(epishod : Epishod?) {
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        minimizedTopAnchorConstraint.isActive = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
         
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            self.view.layoutIfNeeded()
            
        })
        if epishod != nil {
             playerDetailView.epishod = epishod
        }
      
    }
    
    //MARK:- SetupFunctions
     let playerDetailView = PlayerDetailView.initFromNib()
    
    fileprivate func setupPlayerDetailView(){
  
        view.addSubview(playerDetailView)
        view.insertSubview(playerDetailView, belowSubview: tabBar)
        playerDetailView.translatesAutoresizingMaskIntoConstraints = false
//
        maximizedTopAnchorConstraint = playerDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true
        
        minimizedTopAnchorConstraint =  playerDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor , constant : -64)
//        minimizedTopAnchorConstraint.isActive = true
        
        playerDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        playerDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
   
    }
    
 
    
    fileprivate func setupViewControllers(){
        
        let favoritesController = generateNavigationController(with: FavoritesController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites"))
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

