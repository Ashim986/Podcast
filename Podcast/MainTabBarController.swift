//
//  ViewController.swift
//  Podcast
//
//  Created by ashim Dahal on 3/29/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple
    
        setupViewControllers()
        
    }
    
    
    //MARK:- SetupFunctions
    
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

