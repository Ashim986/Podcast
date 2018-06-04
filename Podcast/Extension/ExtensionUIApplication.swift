//
//  ExtensionUIApplication.swift
//  Podcast
//
//  Created by ashim Dahal on 6/3/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit


extension UIApplication {
    
    static func mainTabBarController() -> MainTabBarController? {
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        return mainTabBarController
    }
}

